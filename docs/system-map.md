# System Map — will-style

## What this is

`will-style` (gem name `will_style`, currently `v6.0.3`) is a Rails engine that packages shared front-end assets — Bootstrap-based SCSS, vanilla-JS UI behaviors, a custom icon font, brand assets, and transactional-email partials — for consumption by WILL Interactive's Rails applications (Launchpad is one consumer). It ships no business logic, no models, no controllers, and no authentication surface area of any kind.

## Architecture overview

- **Entry point**: [`lib/will_style.rb`](../lib/will_style.rb) requires [`lib/will_style/engine.rb`](../lib/will_style/engine.rb).
- **`WillStyle::Engine < Rails::Engine`** ([`lib/will_style/engine.rb:10-27`](../lib/will_style/engine.rb#L10-L27)), with `isolate_namespace WillStyle`. It requires and wires in five gems at load time: `dartsass-sprockets`, `bootstrap`, `autoprefixer-rails`, `importmap-rails`, `turbo-rails` ([`engine.rb:1-7`](../lib/will_style/engine.rb#L1-L7)).
- Two initializers:
  - `will_style.javascript` ([`engine.rb:13-15`](../lib/will_style/engine.rb#L13-L15)) adds `app/javascript` to `config.assets.paths`.
  - `will_style.importmap`, run `before: "importmap"` ([`engine.rb:17-26`](../lib/will_style/engine.rb#L17-L26)): builds a `WillStyle.importmap` (`Importmap::Map`), draws **both** the host app's `config/importmap.rb` and the engine's own, sets a cache sweeper watching `app/javascript`, and hooks a `before_action` onto `ActionController::Base` to re-check the sweeper every request.
- **`WillStyle` module singleton** ([`engine.rb:30-44`](../lib/will_style/engine.rb#L30-L44)): `attr_accessor :importmap`; `load!` (a no-op, called at the bottom of the file — [`engine.rb:47`](../lib/will_style/engine.rb#L47)); `gem_path`; and `stylesheets_path`.
  - **Bug found**: `stylesheets_path` ([`engine.rb:41-43`](../lib/will_style/engine.rb#L41-L43)) calls `assets_path`, which is never defined anywhere in this file or module. Calling `WillStyle.stylesheets_path` would raise `NoMethodError`. A repo-wide grep found no callers of `stylesheets_path` or `gem_path` — both appear to be dead/broken code.
  - Line 29's comment, "Using bootstrap-sass initialization," is stale — the code no longer touches bootstrap-sass.
- No other Ruby classes/modules exist in `lib/`. All Ruby-side logic outside the engine itself is [`app/helpers/will_style/library_helpers.rb`](../app/helpers/will_style/library_helpers.rb) — one method, `icon(style, name, text = nil, html_options = {})`, generating a Font Awesome `<i>` tag.

## Dependency graph

**Gem runtime dependencies** ([`will_style.gemspec:18-26`](../will_style.gemspec#L18-L26)): `rails >= 8.0`, `bootstrap ~> 5.3`, `dartsass-sprockets ~> 3.2`, `autoprefixer-rails ~> 10.4`, `turbo-rails ~> 2.0`, `importmap-rails ~> 2.2`. Only dev dependency: `bundler ~> 4.0`.

**npm dependencies** ([`package.json`](../package.json)): runtime `bootstrap ~5.3.8` (used as an SCSS source, not shipped as JS); dev-only `del`, `gulp`, `gulp-sharp-responsive` (private git fork), `require-dir`, `sharp` — these support only the local responsive-image gulp task, not the gem's shipped output.

Full version-by-version detail is in [`dependency-audit.md`](dependency-audit.md).

## Build & distribution flow, end to end

**Stylesheets**: source SCSS lives under [`lib/assets/stylesheets/will_style/`](../lib/assets/stylesheets/will_style) (58 partials: core, mixins, elements, components, animated-elements, libraries), entered via [`lib/assets/stylesheets/will_style.scss`](../lib/assets/stylesheets/will_style.scss) (`@import "will_style/core"`, `$include-type: "rails"`) plus a separate [`email.scss`](../lib/assets/stylesheets/will_style/email.scss) entry point for inline email styling. Compilation is delegated entirely to the host app's `dartsass-sprockets` (Dart Sass) via the Sprockets pipeline — there is no SCSS compile step inside this repo's own gulp/build tooling. `lib/assets` is not explicitly registered as an asset path anywhere in this repo's own code (`engine.rb` only explicitly adds `app/javascript`); it is picked up via Sprockets-rails' own convention of auto-registering `lib/assets/{stylesheets,images,javascripts}` for engines — implicit, not something this repo wires up itself.

**JavaScript — two coexisting loading systems for the same files**:
1. A legacy Sprockets manifest, [`app/javascript/will_style.js`](../app/javascript/will_style.js), using `//= require` directives in explicit order (vendor → core → features → components → forms) across all 18 files under `app/javascript/will_style/`.
2. [`config/importmap.rb`](../config/importmap.rb) (2 lines): `pin_all_from "../app/javascript/will_style", under: "will_style"` and `pin "will_style", to: "will_style.js", preload: true`, wired into the host app via the `will_style.importmap` initializer above.

All 18 files are plain `(function() { 'use strict'; ... })();` IIFEs (zero `import`/`export` syntax) attaching to a global `window.WillStyle` namespace, first established in [`core/settings.js`](../app/javascript/will_style/core/settings.js) and [`core/events.js`](../app/javascript/will_style/core/events.js). `settings.js` defines `window.WillStyle.Settings.pageChangeEvent = "turbo:load"`, which the feature/component/form scripts key their re-initialization off of. Correctness depends on load order and pre-existing globals — fragile under ESM's per-module execution semantics, which importmap-rails uses (`<script type="module">`). Having both loading systems active for the same file set looks like an incomplete Sprockets→importmap migration rather than an intentional dual-support design (see [open-questions.md](open-questions.md)).

[`config/initializers/assets.rb`](../config/initializers/assets.rb) additionally force-precompiles `will_style/email.css`, five favicon assets, plus `bootstrap.min.js` and `popper.js` — a Sprockets-era precompile list that predates the importmap setup and still references the raw Bootstrap JS bundle even though nothing in this gem calls Bootstrap's JS API directly (see Frontend approach, below).

**Icon font**: source SVGs live in [`will-icons/glyphs/`](../will-icons/glyphs) (13 files). The compiled font (`.eot`/`.svg`/`.ttf`/`.woff`, no `.woff2`) lives at `lib/assets/fonts/will-icons/`. **There is no build tooling for this in the repo** — a comment in [`lib/assets/stylesheets/will_style/core/_will_icons.scss`](../lib/assets/stylesheets/will_style/core/_will_icons.scss) ("working around fontastic making will icons a monospace font...") confirms the font is generated by an external third-party tool (Fontastic, fontastic.me) outside this repo, with the output manually committed. CSS classes like `.will-icon-play:before { content: '\e803'; }` map to the compiled font's Unicode PUA codepoints. Two separate `@font-face` declarations exist for different consumers: `core/will_icons/_rails.scss` (uses Sprockets' `asset-url()`) and `core/will_icons/_node.scss` (plain URL variable) — confirming the SCSS tree is designed to be consumed both through the Rails asset pipeline and standalone/node Sass compilation.

**Local image-processing pipeline** (dev tool, not part of the gem's shipped assets): [`gulpfile.js`](../gulpfile.js) → `require-dir` auto-loads [`gulp/responsiveImages.js`](../gulp/responsiveImages.js), which defines three gulp tasks (`clear-responsive-images`, `copy-svgs`, `generate-responsive-images`) that pipe `src/**/*.{gif,jpg,png}` through `gulp-sharp-responsive`, generating images at Bootstrap's grid breakpoints (540/768/960/1140/1320/1920px) in original format and WebP. `src/` and `dist/` are gitignored — this operates on local/uncommitted assets and has no npm script entry (invoked directly via `npx gulp <task>`; `package.json` defines no `scripts`).

**Email partials**: [`app/views/will_style/components/email/`](../app/views/will_style/components/email) (`_button`, `_footer`, `_styles`, `_table`) plus [`_email.html.erb`](../app/views/will_style/components/_email.html.erb) are meant to be inlined by `premailer-rails` in the consuming app, per [`Readme.md`](../Readme.md) ("We use premailer-rails to style emails inline. Be sure to include it in your Gemfile if you're sending emails"). `premailer-rails` is **not** a declared dependency of this gem — it's the consuming app's responsibility, documented only in the README.

## Frontend approach

- Vanilla JS, no framework, no jQuery (confirmed via repo-wide grep — zero hits for `jquery`/`$(`/`jQuery`).
- Bootstrap 5.3 is used only as an SCSS source (variable overrides + component imports in [`lib/assets/stylesheets/will_style/_site.scss`](../lib/assets/stylesheets/will_style/_site.scss)) and via its class/DOM conventions. **Bootstrap's own JS runtime is not actually invoked**: [`app/javascript/will_style/components/dropdowns.js`](../app/javascript/will_style/components/dropdowns.js) is a hand-rolled hover-to-open reimplementation that manipulates `.dropdown`/`.dropdown-menu`/`.dropdown-toggle` classes directly (comment: "Adding hover functionality to the bootstrap dropdowns"), and [`components/modals.js`](../app/javascript/will_style/components/modals.js) repositions Bootstrap modals in the DOM. No `data-bs-*` (or legacy `data-toggle`/`data-target`) attributes appear anywhere in this repo's own views or JS, so Bootstrap's native data-attribute-driven JS components aren't relied on here — yet `bootstrap.min.js`/`popper.js` are still force-precompiled ([`config/initializers/assets.rb:10-11`](../config/initializers/assets.rb#L10-L11)).
- FontAwesome icons are available two ways: (1) the `icon` helper in `library_helpers.rb` (Font Awesome CSS classes), and (2) a hardcoded external Kit script — [`app/views/will_style/libraries/_fontawesome.html.erb`](../app/views/will_style/libraries/_fontawesome.html.erb): `<script src="https://kit.fontawesome.com/952987fa81.js" crossorigin="anonymous">` — an account-specific token embedded directly in a partial, unpinned/unversioned.
- Separately, the custom `will-icons` font (see above) covers a small set of brand-specific glyphs (play/pause/arrows/logo) not available in Font Awesome.

## Background jobs

None. No `ActiveJob`, no job classes, no queue configuration anywhere in the repo — expected, since this gem ships no business logic.

## External integrations

- **FontAwesome Kit** — external CDN script with an embedded token, loaded via `_fontawesome.html.erb`.
- **Fontastic** (fontastic.me) — external, manual, out-of-repo tool used to generate the `will-icons` font from the SVGs in `will-icons/glyphs/`. No account/access info, versioning, or regeneration instructions exist in the repo.
- **Google Analytics** — a feature hook exists at [`app/javascript/will_style/features/google-analytics.js`](../app/javascript/will_style/features/google-analytics.js) (behavior only; no embedded tracking ID found in this repo).
- **premailer-rails** — expected but not declared; consuming app's responsibility per the README.

## Test strategy and actual measured coverage

**None.** No `spec/` or `test/` directory anywhere in the repo. [`Rakefile`](../Rakefile) defines only an `RDoc::Task` for generating documentation from `app/helpers/**/*.rb` — there is no `test`/`spec` Rake task. No RSpec/Minitest/Jest/Mocha dependency anywhere. No `.rubocop*`, `.eslintrc*`, or `.stylelintrc*` config. No `.github/workflows` or any other CI configuration exists in the repo. **Measured coverage: 0%.** Everything here is verified manually/visually today.
