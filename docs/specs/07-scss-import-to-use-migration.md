# 07 — SCSS @import → @use migration (P1)

## Current State

58 SCSS partials under `lib/assets/stylesheets/will_style/` use the legacy `@import` directive 22 times vs. `@use` once (`elements/buttons/_overrides.scss:5`). `dartsass-sprockets ~> 3.2` runs on Dart Sass, which deprecates `@import` and will eventually remove it.

## Desired Outcome

All internal SCSS uses `@use`/`@forward` instead of `@import`, with no functional or visual change to compiled output in any consuming app.

## Recommended Approach

Convert one partial first as a pilot — pick a leaf-level file with few cross-file references — to confirm `dartsass-sprockets` handles `@use` module namespacing end-to-end. Pay special attention to the Bootstrap variable-override files (`_site.scss` and friends): `@use` scopes variables/mixins by namespace and doesn't leak them globally the way `@import` does, so Bootstrap variable overrides may need explicit `@forward ... show` or `with()` configuration to keep working — this is the most likely source of a silent visual regression. Once the pilot validates the approach, convert the rest in dependency order (leaves first, entry points like `will_style.scss` and `email.scss` last).

## Risks and Tradeoffs

The stricter scoping of `@use` is the core risk: a Bootstrap variable override that silently falls back to Bootstrap's default (instead of erroring) would ship a subtle visual regression across all four consuming apps with no test coverage to catch it. Mitigate with a compiled-CSS diff, not just "it compiles without errors."

## Rollback Plan

Land as one PR per stylesheet subdirectory (not one giant PR) so a broken partial can be reverted independently without unwinding the whole migration.

## Acceptance Criteria

- Compiled CSS output is visually identical before/after for a representative host app (diff via `sass` output or a visual regression check).
- `dartsass-sprockets` compilation produces zero `@import` deprecation warnings.

## Dependencies

[05-lint-and-ci.md](05-lint-and-ci.md).

## Estimated Complexity

Medium — mechanical, but touches nearly every stylesheet file.

## Coding Agent Safe?

Yes for the pilot and mechanical conversion; a human should specifically review the Bootstrap-variable-override files, where `@use` scoping most commonly causes silent visual regressions.

**Note**: don't run this concurrently with [08-remove-will-icons.md](08-remove-will-icons.md) — both touch `lib/assets/stylesheets/will_style/core/` and `mixins/`. Land 08 first.

## Progress log (in progress as of 2026-08-11)

**Tooling note**: the official `sass-migrator module` tool (via `npx sass-migrator`) works for this codebase but needs care — will-style `@import`s Bootstrap's *internal* partials directly (not just its public API), so a naive `--migrate-deps` run tries to migrate vendored gem files too. It also silently misses some leaf files that reference bare external variables/mixins but have no `@import` of their own — those need manual fixup, caught reliably by attempting to actually compile the result (an undefined-variable error, loud and immediate) rather than trusting the dry-run diff alone. **Verification method going forward**: compile before/after (via `sass-embedded` directly, matching Launchpad's real `@import "will_style"; @import "will_style/app";` combination, not just `will_style.scss` alone) and diff; if not byte-identical, confirm via a sorted-line diff that it's a pure block reorder with no selector/property overlap before accepting it.

- **`email.scss`** — converted to `@use`. Verified byte-identical compiled output.
- **`core/variables/_colors.scss` + `core/_colors.scss` merged**, briefly, into a single `core/_colors.scss` — then **split again** once the rest of `_core.scss` surfaced a hard rule about mixing `@import` and `@use`/`@forward` in the same compilation (see "Key finding" below): `core/_colors.scss` is now variables-only (color palette + the Bootstrap `!default` overrides); the `.will-*` utility classes and `html, body` background rule that consumed them moved to a new `elements/_colors.scss`. This split isn't cosmetic — it's what makes the rest of the conversion possible without duplicating CSS.
- **Key finding — a module with real CSS output cannot safely be both `@import`'d and `@use`'d/`@forward`'d in the same compilation.** `@import` and `@use` each get their own separate module-loading cache ("world"); a plain-variables module loaded both ways just gets its (deterministic, side-effect-free) values computed twice, harmlessly — but a module with top-level CSS rules gets those rules **emitted once per world it's loaded through**, silently duplicating output. Discovered by diffing compiled CSS and finding `.will-teal { ... }` present 2–4 times instead of once. `core/_colors.scss` needed to stay `@import`-reachable (its Bootstrap `!default` overrides only take effect if they land in the same `@import`-based global scope `bootstrap/variables` reads from — `@forward` alone doesn't leak them there) while also being `@use`-needed by several newly-migrated files — hence the split above: the now CSS-free `core/_colors.scss` is safe to load both ways, and the new `elements/_colors.scss` (CSS output) is `@use`'d exactly once.
- **`_core.scss`** — the will-style-only portion (not Bootstrap-coupled) converted: `core/colors` (as above), `core/variables/global`, `core/deferred-styles`, `core/accessibility`, `core/typography/web`, `mixins/base`, `mixins/backgrounds`, `mixins/gradients`, `mixins/layout`, `mixins/underlined-elements`, `mixins/shadows`, `mixins/animated-elements`, `mixins/fontawesome`, `core/transitions`, `elements/colors`, `elements/gradients`, `elements/image-loading`. Files whose members are still consumed bare by not-yet-migrated files elsewhere in the tree (essentially everything under `_site.scss`) are `@forward`'d, not just `@use`'d, so those legacy consumers keep working — verified by leaving `_site.scss`'s whole domain untouched and confirming the combined compile still succeeds. `$include-type` (controls `will-style-bg-url()`'s asset-path mode) is now configured once, centrally, via `@forward "will_style/mixins/base" with ($include-type: "rails")` in `_core.scss` — Sass only allows a module to be configured at its first load, so this couldn't be set redundantly at each call site.
- **Left as `@import`, deferred**: everything Bootstrap-coupled — `bootstrap/functions`, `bootstrap/variables`, `bootstrap/variables-dark`, `core/variables/type`, `core/variables/bootstrap_pre`, `core/variables/bootstrap`, `core/type`, and all the `bootstrap/*` imports in the Mixins/Transitions/Images/Layout/Libraries sections. These read and write Bootstrap's own `!default` variables in a way that fundamentally requires the shared `@import` global scope; converting them needs Bootstrap's `@use ... with()` configuration pattern, which is a separate, larger redesign (see Recommended Approach above) — not attempted in this pass.
- Verified throughout via the full `will_style` + `will_style/app` compile: final state is content-identical to the pre-`_core.scss`-work baseline (sorted-line diff empty — same rule set, some non-conflicting blocks reordered, same as the `email.scss`/colors-merge slice). Full toolchain (Rubocop, RSpec, Stylelint, `gem build`) clean throughout.
- Remaining: `_site.scss` (by far the largest remaining surface — dozens of files, all currently relying on the `@forward`ed bare access described above), `_app.scss`, `_libraries.scss`.
