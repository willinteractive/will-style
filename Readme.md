# will_style

A Rails engine that provides WILL Interactive's shared front-end styling: Sass built on Bootstrap 5, importmap-managed JS behaviors (real ES modules), view partials/helpers, and brand assets (logos, fonts, favicons). It also ships a small Gulp/Sharp pipeline for generating responsive marketing images. No business logic — no models, no controllers, no auth.

## Requirements

- Rails >= 8.0
- `bootstrap` ~> 5.3
- `dartsass-sprockets` ~> 3.2
- `autoprefixer-rails` ~> 10.4
- `importmap-rails` ~> 2.2
- `turbo-rails` ~> 2.0

## Installation

Add to your Gemfile:

```ruby
gem "will_style"
```

### Stylesheets

In your app's `application.scss` (or equivalent):

```scss
@import "will_style";
```

### JavaScript

`will_style` registers its own importmap pins and wires them into the host app's `Rails.application.importmap` automatically — nothing to configure by hand. Import the aggregate entry point from your application entry point:

```js
import "will_style"
```

This pulls in the engine's core settings/events, feature behaviors (image loading, animated elements, video/image backgrounds, etc.), UI components (dropdowns, navbar, modals, pop-out), and form helpers (expanding textareas, file sizes, required inputs, URL formatting) — 20 real ES modules under `app/javascript/will_style/`, re-initializing on `turbo:load`.

### View helpers & partials

- `WillStyle::LibraryHelpers#icon` renders a Font Awesome `<i>` tag.
- `will_style/libraries/_fontawesome` loads Font Awesome via a Kit script tag.
- Partials under `will_style/components` cover common layout pieces: `_picture`, `_picture_set`, `_favicon`, `_footer`, `_deferred_styles`, `_will_logo_svg`, and an `email/` set (`_button`, `_footer`, `_styles`, `_table`) for building transactional/marketing emails.

### Optional libraries

We use premailer-rails to style emails inline. Be sure to include it in your Gemfile if you're sending emails. It's intentionally not a declared dependency of this gem, so apps that don't send email don't have to carry it — if you render the `will_style/components/email` layout without it installed, a warning is logged to `Rails.logger` since the email will otherwise render unstyled in most clients.

## Using this package in a frontend app (npm)

Non-Rails frontend apps can pull this repo in directly as a git dependency rather than through RubyGems. In the consuming app's `package.json`:

```json
"dependencies": {
  "will-style": "https://github.com/willinteractive/will-style.git#7.1.0"
}
```

Pin to a tag (matching the gem version, e.g. `7.1.0`) rather than a branch, so the frontend and Rails sides stay in sync.

There's no bundled entry point (`main`/`exports`) published, so consumers import the Sass, JS, and assets directly by path from `node_modules/will-style`:

```scss
// Sass
@import "will-style/lib/assets/stylesheets/will_style";
```

```js
// JS — the aggregate entry point, or individual components/features
import "will-style/app/javascript/will_style";
import "will-style/app/javascript/will_style/components/navbar";
```

```scss
// Fonts, logos, patterns, favicons
url("will-style/lib/assets/images/will-style/logos/master-logos/master-light.svg");
```

Adjust the paths to whatever your bundler's resolution/alias setup expects.

## Responsive image pipeline

Marketing/poster images live in `src/` (gitignored). The Gulp task resizes and converts them (via `sharp`/`fast-glob`) into multiple widths and WebP variants under `dist/` (also gitignored) — this is a local dev tool, not part of the shipped gem.

```sh
npm install
npx gulp generate-responsive-images
```

This clears `dist/`, copies any SVGs as-is, and generates JPEG/PNG + WebP outputs at 540/768/960/1140/1320/1920px widths for everything under `src/` (the largest, 1920px, is left unsuffixed; the rest get a `-{width}` suffix). `npx gulp clear-responsive-images` / `npx gulp copy-svgs` are the sub-tasks.

## Development

- Install: `bundle install` (requires bundler `4.0.x`) and `npm install`.
- Test: `bundle exec rspec` (RSpec + Combustion dummy app, see `spec/`).
- Ruby lint: `bundle exec rubocop` (`-a`/`-A` to autocorrect).
- JS/CSS lint: `npm run lint` (`npm run lint:js` / `npm run lint:css` individually).
- CI (`.github/workflows/ci.yml`) runs all of the above on every push/PR.

See `CHANGELOG.md` for release history.
