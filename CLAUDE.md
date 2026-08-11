# CLAUDE.md

`will-style` (gem `will_style`, currently `6.0.3`) is a Rails engine shipping shared SCSS/Bootstrap styles, vanilla-JS UI behaviors, and email partials, consumed via git reference by four apps: Launchpad, Access, Learning, Veils-Player. It has **no business logic** — no models, no controllers, no auth.

## Stack

Rails engine, requires `rails >= 8.0` and Ruby `>= 3.4.10` (both raised 2026-08-11 — `access`/`learning` are being modernized to match). Bootstrap 5.3, `dartsass-sprockets` (Dart Sass) for SCSS, `importmap-rails` for JS (the Sprockets manifest is gone as of item C1, 2026-08-11 — `app/javascript/will_style.js` is now a plain ESM entry point, not a `//= require` manifest). Node `>=18.12.0` for the local dev tooling only.

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
- `app/javascript/will_style/` — 21 vanilla-JS IIFE files sharing a global `window.WillStyle` namespace, re-initializing on `turbo:load`. Loaded solely via `config/importmap.rb` pins, aggregated by `app/javascript/will_style.js` (a plain ESM `import`-list entry point, not a Sprockets manifest as of item C1). New file: add it under `app/javascript/will_style/`, it'll be auto-pinned by `pin_all_from`, but you still need to add an explicit `import` line to `will_style.js` in the right load-order slot — nothing does that automatically.
- `app/views/will_style/` — presentational ERB partials, including `components/email/` (styled for `premailer-rails` inlining in the consuming app — not a declared dependency yet, see item P4).
- `docs/` — the modernization planning docs: `system-map.md` (architecture), `dependency-audit.md`, `risk-notes.md`, `open-questions.md` (resolved), `MIGRATION.md` (the roadmap), `specs/` (one spec per roadmap item), `standards.md` (target-state conventions).

## Conventions a linter won't catch

- SCSS: `@use` is the target pattern going forward (see `docs/standards.md`); P1 (`@import`→`@use` migration) is done as of 2026-08-11 for everything except Bootstrap-coupled files, which stay on `@import` **indefinitely** — confirmed the vendored `bootstrap` gem itself is still 100% `@import`-based internally (5.3.8), so there's no `@use` surface on Bootstrap's side to convert onto yet (tracked as `B4`, blocked upstream). Don't add new `@import`s to a will-style-only file; do keep `@import` in any file that reaches a bare Bootstrap variable. (Stylelint's `at-rule-no-deprecated` and `scss/no-global-function-names` are intentionally off until `B4` lands — don't re-enable them piecemeal, since the remaining `@import` usage is now permanent-until-upstream-changes, not a to-do list.)
- JS: keep the IIFE + `window.WillStyle` pattern in any file you touch **unless** you're doing the item-16 ESM conversion — don't half-convert one file to ES modules while its siblings still expect the global.
- Any new dependency on Bootstrap's own JS runtime should be avoided — this gem deliberately reimplements dropdown/modal behavior by hand rather than invoking Bootstrap's JS API (see `docs/system-map.md`).

## Do not modify without checking `docs/MIGRATION.md` first

- `will-icons/` and its SCSS/view references — slated for full removal (item P2), not modernization. Don't invest in fixing it.
- `app/views/will_style/libraries/_fontawesome.html.erb` — the embedded Kit token is account-specific; a replacement is being spiked (item P5/B1), don't swap it ad hoc.
- Anything under `lib/assets/fonts/`, `lib/assets/images/` — vendored/brand assets, not to be regenerated casually.
