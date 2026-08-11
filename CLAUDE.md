# CLAUDE.md

`will-style` (gem `will_style`, currently `6.0.3`) is a Rails engine shipping shared SCSS/Bootstrap styles, vanilla-JS UI behaviors, and email partials, consumed via git reference by four apps: Launchpad, Access, Learning, Veils-Player. It has **no business logic** — no models, no controllers, no auth.

## Stack

Rails engine, requires `rails >= 8.0` and Ruby `>= 3.4.10` (both raised 2026-08-11 — `access`/`learning` are being modernized to match). Bootstrap 5.3, `dartsass-sprockets` (Dart Sass) for SCSS, `importmap-rails` + a legacy Sprockets manifest for JS (dual-loading, being consolidated — see item C1). Node `>=18.12.0` for the local dev tooling only.

## Commands

- Install: `bundle install` (Ruby side, requires bundler `4.0.x` — `gem install bundler -v 4.0.18` if missing) and `npm install` (JS side).
- Test: `bundle exec rspec` (RSpec + Combustion dummy app, see `spec/`).
- Ruby lint: `bundle exec rubocop` (`-a`/`-A` to autocorrect).
- JS/CSS lint: `npm run lint` (`npm run lint:js` / `npm run lint:css` individually).
- Dependency audit: `bundle exec bundle-audit check --update`.
- Build the gem: `gem build will_style.gemspec`.
- Local responsive-image generation (dev tool only, not part of the shipped gem): `npx gulp generate-responsive-images` (place source images in `src/`, output lands in `dist/`; both gitignored). `npx gulp clear-responsive-images` / `npx gulp copy-svgs` are the sub-tasks.
- CI (`.github/workflows/ci.yml`) runs all of the above as separate jobs on every push/PR.

## Directories that matter

- `lib/will_style/engine.rb` — the `Rails::Engine` definition: asset path wiring, the importmap initializer. Everything else in the gem hangs off this.
- `lib/assets/stylesheets/will_style/` — all SCSS source (58 partials: core, mixins, elements, components, libraries). This is the gem's primary deliverable.
- `app/javascript/will_style/` — 18 vanilla-JS IIFE files sharing a global `window.WillStyle` namespace, re-initializing on `turbo:load`. Currently double-loaded via both `app/javascript/will_style.js` (Sprockets) and `config/importmap.rb` — don't add a 19th file without updating both until item C1 lands.
- `app/views/will_style/` — presentational ERB partials, including `components/email/` (styled for `premailer-rails` inlining in the consuming app — not a declared dependency yet, see item P4).
- `docs/` — the modernization planning docs: `system-map.md` (architecture), `dependency-audit.md`, `risk-notes.md`, `open-questions.md` (resolved), `MIGRATION.md` (the roadmap), `specs/` (one spec per roadmap item), `standards.md` (target-state conventions).

## Conventions a linter won't catch

- SCSS: `@use` is the target pattern going forward (see `docs/standards.md`); most existing files still use the legacy `@import` — don't add new `@import`s, migrate the file you're touching if it's small. (Stylelint's `at-rule-no-deprecated` and `scss/no-global-function-names` are intentionally off until item P1 lands — don't re-enable them piecemeal.)
- JS: keep the IIFE + `window.WillStyle` pattern in any file you touch **unless** you're doing the item-16 ESM conversion — don't half-convert one file to ES modules while its siblings still expect the global.
- Any new dependency on Bootstrap's own JS runtime should be avoided — this gem deliberately reimplements dropdown/modal behavior by hand rather than invoking Bootstrap's JS API (see `docs/system-map.md`).
- `lib/assets/stylesheets/will_style/mixins/_layout.scss` has two `@mixin stretch` definitions (the second shadows the first) — known, flagged, unresolved (`docs/open-questions.md` #12). Don't "clean this up" without checking that thread first.

## Do not modify without checking `docs/MIGRATION.md` first

- `app/javascript/will_style.js` and `config/importmap.rb` — dual JS loading is intentional-for-now (item C1 resolves it); removing one without the other breaks a consumer.
- `will-icons/` and its SCSS/view references — slated for full removal (item P2), not modernization. Don't invest in fixing it.
- `app/views/will_style/libraries/_fontawesome.html.erb` — the embedded Kit token is account-specific; a replacement is being spiked (item P5/B1), don't swap it ad hoc.
- Anything under `lib/assets/fonts/`, `lib/assets/images/` — vendored/brand assets, not to be regenerated casually.
