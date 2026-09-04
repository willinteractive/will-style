# Changelog

All notable changes to `will_style` are documented here. Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## [7.1.1] — 2026-09-04

Bugfix release. No public API changes; safe upgrade for anyone on `7.1.x`.

### Fixed

- **`mixins/_fontawesome.scss` targeted a FontAwesome Kit version that no longer matches the team's Kit.** The `fontawesome-icon` mixin's `font-family` hardcoded `"Font Awesome 6 Pro"`; the team's Kit is now on FontAwesome 7. Updated to `"Font Awesome 7 Pro"`.
- **`libraries/_will_paginate.scss` pagination arrows.** Switched from `fa-chevron-left`/`fa-chevron-right` (`\f053`/`\f054`) to `fa-angle-left`/`fa-angle-right` (`\f104`/`\f105`), and removed the old absolute-position/sizing `:before` rule on `a.previous_page`/`a.next_page` — it rendered incorrectly against the new glyphs.

## [7.1.0] — 2026-08-12

Feature release. No breaking public API changes; safe upgrade for anyone on `7.0.x`.

### Added

- **`WillStyle::Engine` now auto-precompiles the entire `lib/assets/images` tree** instead of relying on a hand-maintained list. Previously only the favicon files were declared in `config/initializers/assets.rb`, so anything else under `lib/assets/images` (logos, patterns, etc.) 404'd in a consuming app unless that app kept its own copy of the list in sync. The engine now enumerates the tree itself at boot and precompiles every file, the same fix already applied to the JS behavior files in `7.0.1`. The old hand-listed favicon entries in `config/initializers/assets.rb` were removed as redundant.

### Changed

- **Footer redesign.** `components/_footer.html.erb` now renders the WILL Interactive master logo (`will-style/logos/master-logos/master-light.svg`) next to the copyright year instead of plain text, and the policy links (Privacy Policy, SaaS Agreement, Terms, optional Support) switched from `&nbsp;`-separated spacing to a flex layout (`gap-4`) with bold (`fw-bold`) link text.
- `components/_footer.scss` moved back from `@use` to `@import` in `_site.scss`, since it now references the bare Bootstrap variable `$small-font-size` to size the new logo — consistent with this repo's standing convention (see `docs/standards.md`) of keeping `@import` in any file that reaches a bare Bootstrap variable.

## [7.0.2] — 2026-08-12

Bugfix release, more issues found live-testing `7.0.x` against Launchpad. No public API changes; safe upgrade for anyone on `7.0.x`.

### Fixed

- **`.navbar .nav-link.active` didn't get the hover/focus text color.** `components/_navbar.scss`'s `.nav-link` only applied `$will-white` on `:hover`/`:focus`, so an active nav link fell back to the default (dark) link color and was unreadable against the dark navbar background. Added an explicit `&.active` rule alongside the existing hover/focus one.

### Added

- **`.no-before` / `.no-after` utility classes** (`elements/_pseudo-elements.scss`), for suppressing a `:before`/`:after` pseudo-element that's already been injected by another style (e.g. Bootstrap's dropdown-toggle caret, accordion-button icon) without overriding the source selector itself.

## [7.0.1] — 2026-08-12

Bugfix release. This is the live-consumer smoke test 7.0.0 flagged as outstanding — run against Launchpad, which caught three real bugs the JS module conversion introduced or exposed. No public API changes; safe upgrade for anyone on `7.0.0`.

### Fixed

- **JS never loaded in any consuming app.** `WillStyle::Engine` built its own private `WillStyle.importmap` (drawing both the host app's and the engine's `config/importmap.rb`), but nothing wired that into `Rails.application.importmap` — the map `javascript_importmap_tags` actually renders. Every consumer's browser-facing importmap was missing all 20 `will_style/*` submodule pins, so `app/javascript/will_style.js`'s `import "will_style/core/settings"` etc. (real ESM as of 7.0.0) failed to resolve and `window.WillStyle` never initialized. Fixed by registering the engine's `config/importmap.rb` and asset-watch path directly into the host app's `config.importmap.paths`/`cache_sweepers`, the standard importmap-rails engine integration pattern.
- **`pin_all_from` in this gem's own `config/importmap.rb` resolved to nothing.** It used a relative directory (`'../app/javascript/will_style'`), but `Importmap::Map#absolute_root_of` always resolves relative `pin_all_from` paths against the *host app's* `Rails.root`, never the declaring file's own location — so in every consumer it silently expanded to zero files. This bug predates 7.0.0 and was masked by the issue above (nothing ever drew this file into a map anyone rendered). Anchored the path to `WillStyle::Engine.root` instead.
- **Sprockets `AssetNotPrecompiledError` on every `will_style/*.js` file**, once the above two fixes made those pins real. `config.assets.precompile` never listed the individual behavior files, only the `will_style.js` aggregate. Declared them via `WillStyle::Engine`'s asset initializer so no consuming app needs to hand-maintain this list. (A `Regexp` entry was tried first — looks idiomatic — but Sprockets 4's resolver calls `.start_with?` directly on precompile entries and raises on anything that isn't a String; switched to enumerating literal logical paths at boot instead.)
- **`event.target.matches is not a function`**, thrown from `forms/selected-buttons.js`'s document-level capture-phase click listener (and, on inspection, three more listeners with the identical gap: `forms/url-formatting.js`, `features/focused-form-elements.js`, `features/spannable-elements.js`). `Event.target` is not guaranteed to be an `Element` — `animated-elements.js` already guarded against this (`current.matches && current.matches(...)`) but the guard was never applied consistently across the other JS behavior files. This bug predates 7.0.0 (present unchanged since at least `6.0.3`) but had never been exercised by a live click sequence until this smoke test.

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
