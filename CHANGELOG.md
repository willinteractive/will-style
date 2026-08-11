# Changelog

All notable changes to `will_style` are documented here. Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## [7.0.0] — 2026-08-11

Breaking release, part of the 2026 modernization effort (see `docs/MIGRATION.md`). Rollout schedule: Launchpad 2026-08-11, Access 2026-08-14, Learning 2026-08-25, Veils-Player 2026-09-08.

**Not yet verified in a live consuming app**: the JS changes below (Sprockets manifest removal, ES module conversion) were verified as far as this repo allows — lint, syntax checks, full Ruby/JS/CSS toolchain — but not exercised in a real browser. Smoke-test against Launchpad as part of this rollout; if anything surfaces, a `7.0.x` bugfix release is the plan, not a revert of the whole release.

### Breaking

- `required_ruby_version` raised to `>= 3.4.10` (was unset).
- `rails` dependency floor raised to `>= 8.0` (was `>= 7.2.3`, unbounded).
- `will-icons` removed entirely (icon font, SCSS, and view references). Pagination-arrow icons now render via FontAwesome Pro (`mixins/_fontawesome.scss`) instead. The footer's inline WILL glyph is now literal "WILL Interactive" text.
- Sprockets JS manifest (`app/javascript/will_style.js`) removed — `config/importmap.rb` is now the only JS loading path. Any consumer still relying on the Sprockets `//= require will_style` path needs to be on importmap-rails first.
- All 20 behavior files under `app/javascript/will_style/` converted from global-namespace IIFEs to real ES modules (`import`/`export`). `window.WillStyle.Settings`, `.Events`, and `.Forms.initializeExpandingTextareas` remain available as compatibility-shim globals (one, `Events`, is load-bearing for `_deferred_styles.html.erb`) — but any new integration should treat this as deprecated surface, not a stable public API.

### Changed

- Internal SCSS migrated from `@import` to `@use`/`@forward` wherever not blocked by Bootstrap's own SCSS still being `@import`-only (see `docs/specs/07-scss-import-to-use-migration.md`). No visual/functional change — verified via compiled-CSS diffing.
- `premailer-rails` is now an optional, load-time-detected dependency instead of an undeclared assumption.

### Fixed

- Removed a duplicate, dead `@mixin stretch` definition in `mixins/_layout.scss` (the offset-parameter form, shadowed and unused).
