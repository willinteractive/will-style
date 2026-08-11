# CLAUDE.md

`will-style` (gem `will_style`, currently `6.0.3`) is a Rails engine shipping shared SCSS/Bootstrap styles, vanilla-JS UI behaviors, and email partials, consumed via git reference by four apps: Launchpad, Access, Learning, Veils-Player. It has **no business logic** — no models, no controllers, no auth.

## Stack

Rails engine, requires `rails >= 8.0` and Ruby `>= 3.4.10` (both raised 2026-08-11 — `access`/`learning` are being modernized to match). Bootstrap 5.3, `dartsass-sprockets` (Dart Sass) for SCSS, `importmap-rails` + a legacy Sprockets manifest for JS (dual-loading, being consolidated — see item C1). Node `>=18.12.0` for the local dev tooling only.

## Commands

There is currently **no test suite, no lint config, and no CI** in this repo — that's first on the modernization roadmap (`docs/MIGRATION.md` items F4/F5). Until then:

- Build the gem: `gem build will_style.gemspec`
- Local responsive-image generation (dev tool only, not part of the shipped gem): `npx gulp generate-responsive-images` (place source images in `src/`, output lands in `dist/`; both gitignored). `npx gulp clear-responsive-images` / `npx gulp copy-svgs` are the sub-tasks.
- **Before running any npm command**, run `npm install` first — `node_modules` is currently out of sync with the lockfile (stale `gulp`/`sharp`, the latter a live CVE — see `docs/dependency-audit.md`).

## Directories that matter

- `lib/will_style/engine.rb` — the `Rails::Engine` definition: asset path wiring, the importmap initializer. Everything else in the gem hangs off this.
- `lib/assets/stylesheets/will_style/` — all SCSS source (58 partials: core, mixins, elements, components, libraries). This is the gem's primary deliverable.
- `app/javascript/will_style/` — 18 vanilla-JS IIFE files sharing a global `window.WillStyle` namespace, re-initializing on `turbo:load`. Currently double-loaded via both `app/javascript/will_style.js` (Sprockets) and `config/importmap.rb` — don't add a 19th file without updating both until item C1 lands.
- `app/views/will_style/` — presentational ERB partials, including `components/email/` (styled for `premailer-rails` inlining in the consuming app — not a declared dependency yet, see item P4).
- `docs/` — the modernization planning docs: `system-map.md` (architecture), `dependency-audit.md`, `risk-notes.md`, `open-questions.md` (resolved), `MIGRATION.md` (the roadmap), `specs/` (one spec per roadmap item), `standards.md` (target-state conventions).

## Conventions a linter won't catch (yet — none exist)

- SCSS: `@use` is the target pattern going forward (see `docs/standards.md`); most existing files still use the legacy `@import` — don't add new `@import`s, migrate the file you're touching if it's small.
- JS: keep the IIFE + `window.WillStyle` pattern in any file you touch **unless** you're doing the item-16 ESM conversion — don't half-convert one file to ES modules while its siblings still expect the global.
- Any new dependency on Bootstrap's own JS runtime should be avoided — this gem deliberately reimplements dropdown/modal behavior by hand rather than invoking Bootstrap's JS API (see `docs/system-map.md`).

## Do not modify without checking `docs/MIGRATION.md` first

- `app/javascript/will_style.js` and `config/importmap.rb` — dual JS loading is intentional-for-now (item C1 resolves it); removing one without the other breaks a consumer.
- `will-icons/` and its SCSS/view references — slated for full removal (item P2), not modernization. Don't invest in fixing it.
- `app/views/will_style/libraries/_fontawesome.html.erb` — the embedded Kit token is account-specific; a replacement is being spiked (item P5/B1), don't swap it ad hoc.
- Anything under `lib/assets/fonts/`, `lib/assets/images/` — vendored/brand assets, not to be regenerated casually.
