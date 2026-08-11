# Standards — Target State for will-style

What modernized will-style code looks like once `docs/MIGRATION.md` is complete. This is the reference for "what would we do here" when two sessions weeks apart need to make the same call.

## Ruby / gemspec

- `required_ruby_version` is always set and current (`>= 3.4.10` as of this writing — bump it when the team's floor moves, don't let it silently lapse).
- Runtime gem dependencies use `~>` pessimistic constraints, kept current — this repo's dependencies already follow this well; keep doing it.
- `rails` has an explicit floor (`>= 8.0`), no upper bound, per team decision — revisit the floor only alongside a broader Ruby/Rails version bump, and add an upper bound only if a future Rails major changes import/dependency structure in a way that breaks this gem, not preemptively.
- No dead code: a public method with no callers found anywhere (this repo or, as best as can be checked, consumer repos) gets deleted, not left "just in case." If it's genuinely load-bearing for a consumer, that surfaces as a real break, gets reverted, and gets documented — better than silently accumulating unverifiable surface area.
- Optional integrations (e.g. `premailer-rails`) are detected at load time (`defined?`/`Gem::Specification.find_by_name`) rather than declared as hard dependencies, so consumers that don't need the feature don't carry the weight.

## SCSS

- `@use`/`@forward` only — no new `@import`. If you're editing a file that still uses `@import`, migrate it as part of your change rather than adding to the pile.
- When two files' default `@use` namespaces collide (both named e.g. `_gradients.scss` in different directories), **rename one of the files rather than aliasing the `@use`** (`@use "..." as some-alias;`) — team decision, made during the P1 migration. A rename is a one-time fix visible at the file level; an alias has to be remembered and re-applied at every call site. Pick the name that's more accurate to the file's actual content while you're at it (e.g. `elements/_gradients.scss` → `elements/_text-gradients.scss`, since it only ever generated `.text-gradient-*` classes).
- A module with real top-level CSS output cannot safely be both `@import`'d and `@use`'d/`@forward`'d in the same compile — each loading mechanism gets its own module cache, so the CSS gets emitted once per "world" it's reached through, silently duplicating output. This includes two separate `@import`-rooted files each independently `@use`ing the same CSS-emitting module (e.g. `_core.scss` and `_site.scss` are two different `@import` contexts within the same overall compile). If a module needs to be reachable both ways, split its variable/mixin definitions (safe to load from anywhere) from its CSS output (must be `@use`d from exactly one place) into separate files — see `core/_colors.scss` vs. `elements/_colors.scss` for the pattern. Verify any SCSS restructuring by compiling the real `@import "will_style"; @import "will_style/app";` combination before and after and diffing.
- Bootstrap variable overrides are the one place `@use`'s stricter scoping bites hardest — when overriding a Bootstrap variable, verify the compiled CSS actually reflects the override (don't trust "it compiled" alone; `@use` can silently fall back to Bootstrap's default if the override isn't threaded through correctly).
- Two consumption contexts (Rails asset pipeline via `asset-url()`, and plain node/Sass) are a deliberate feature of this gem's SCSS — any new `@font-face` or asset-reference should follow the existing `_rails.scss` / `_node.scss` split pattern rather than hardcoding one context.
- One entry point per consumption target: `will_style.scss` for the full app stylesheet, `email.scss` for the inline-email subset. Don't add a third entry point without a clear reason — fold new styles into the existing structure (core/mixins/elements/components/libraries).

## JavaScript

- Real ES modules (`import`/`export`) only — no new IIFE-style files, no new reads of a global namespace. (This is the target state after item C2; until then, match the existing file's style rather than mixing patterns within one file.)
- No dependency on Bootstrap's own JS runtime. This gem deliberately hand-rolls dropdown/modal/nav behavior rather than calling Bootstrap's JS API — keep that pattern consistent (don't reintroduce `bootstrap.min.js`/Popper as a runtime dependency).
- Re-initialization on Turbo navigation goes through the existing `turbo:load` convention (`core/settings.js`'s `pageChangeEvent`) — new features should hook the same event, not invent a second lifecycle mechanism.
- One loading mechanism: importmap-rails only. No Sprockets manifest (post item C1).

## Testing

- Every engine-level Ruby change (helpers, initializers) gets a corresponding test in the dummy-app harness (item F4) — no exceptions once the harness exists.
- SCSS changes that touch a Bootstrap variable override should include a before/after compiled-CSS check, not just a visual eyeball — there's no automated visual regression tooling yet, so this is a manual discipline until one exists.
- JS behaviors don't have a test harness planned in the current roadmap (would require a browser-level test setup) — until that changes, any JS behavior change should be manually verified against at least one real consuming app before merging.

## Dependency hygiene

- `node_modules` must match the lockfile — if you bump a version in `package.json`, run `npm install` in the same change, not a follow-up.
- No new private/unpublished dependencies (git-URL npm packages, single-maintainer forks) without a documented reason — prefer registry-published, actively maintained packages. `gulp-sharp-responsive` is the counter-example being fixed (item P3), not a pattern to repeat.
- External runtime dependencies (CDN scripts, embedded tokens) should be pinned/versioned where the provider allows it, not left as a live, unpinned script tag — the FontAwesome Kit script is the known exception being revisited (item P5/B1).

## Versioning & release

- Breaking changes are acceptable, coordinated through a major version bump with a written rollout plan across all four consuming apps (Launchpad, Access, Learning, Veils-Player) — not silently shipped in a patch/minor release.
- Every release with user-visible changes gets a `CHANGELOG.md` entry — this doesn't exist yet (start it with the `7.0` release, item C3) but should become standard practice from there on.
- Distribution stays git-reference-based unless the team decides to invest in a RubyGems/npm publish workflow — don't assume a publish step exists.

## Documentation

- Architectural decisions and their "why" belong in `docs/`, not scattered as inline code comments — comments in code should explain non-obvious workarounds only (e.g. the existing `_will_icons.scss` Fontastic-workaround comment was a good instance of this pattern, even though that specific code is being removed).
- `CLAUDE.md` stays one page and points to `docs/` for depth — update it whenever a "do not modify without checking" item resolves (e.g. once item C1 lands, remove the dual-JS-loading warning).
