# Dependency Audit — will-style

Live version data pulled from rubygems.org and the npm registry on 2026-08-11.

## Ruby / Rails

| Item | Before | Now | Notes |
|---|---|---|---|
| `required_ruby_version` | unset | **`>= 3.4.10`** (F2, done 2026-08-11) | `3.4.10` was the latest 3.4.x patch as of 2026-08-11; Ruby 3.4 is supported through 2028-03-31. |
| `rails` | `>= 7.2.3` (unbounded) | **`>= 8.0`** (unbounded above the floor, done 2026-08-11) | Raised after F6's consumer inventory showed `access`/`learning` still on Rails 6.1.x — the team confirmed those two are being modernized to Rails 8 next, so it's a deliberate forcing function rather than an accident. `launchpad` is already on `8.1.3.1`; `access`/`learning` cannot adopt a will-style release built after this change until their own Rails upgrade lands. |

**Security note**: CVE-2026-66066 ("KindaRails2Shell," CVSSv4 9.5) is a critical Active Storage arbitrary-file-read/RCE vulnerability affecting Rails 7.2 before 7.2.3.2, 8.0 before 8.0.5.1, and 8.1 before 8.1.3.1, patched 2026-07-29. This gem does not use Active Storage itself, so it isn't directly exploitable through will-style — but any consuming app should independently confirm it's on a patched Rails, since this gem's floor doesn't guarantee it. ([Rapid7 writeup](https://www.rapid7.com/blog/post/etr-kindarails2shell-cve-2026-66066-critical-arbitrary-file-read-and-possible-remote-code-execution-in-ruby-on-rails/))

## Gemspec runtime dependencies

| Gem | Constraint | Current resolved | Latest available | Maintenance |
|---|---|---|---|---|
| `bootstrap` | `~> 5.3` | 5.3.x | `5.3.8` | Active (last release 2026-01-11). Constraint already tracks latest. |
| `dartsass-sprockets` | `~> 3.2` | 3.2.x | `3.2.1` | Active (last release 2025-04-08). Constraint tracks latest. |
| `autoprefixer-rails` | `~> 10.4` | 10.4.x | `10.4.21.0` | Active (last release 2025-04-12). Constraint tracks latest. |
| `turbo-rails` | `~> 2.0` | 2.0.x | `2.0.23` | Active (last release 2026-01-29). Constraint tracks latest. |
| `importmap-rails` | `~> 2.2` | 2.2.x | `2.2.3` | Active (last release 2026-01-07). Constraint tracks latest. |
| `bundler` (dev) | `~> 4.0` | 4.0.x | `4.0.18` | Active (last release 2026-08-05). Constraint tracks latest. |

**Read**: every declared gem dependency's version constraint already tracks its current latest release — none of these are individually stale. The remaining gem-side risk is the **absence of a `Gemfile.lock`** (there is no root `Gemfile`, so nothing pins the actual resolved dependency tree for local development/testing of this gem itself — every `bundle install` against it floats); that's covered by [04-ruby-test-harness.md](specs/04-ruby-test-harness.md).

## npm dependencies

| Package | Wants | Status |
|---|---|---|
| `bootstrap` (runtime) | `~5.3.8` | OK |
| `gulp` (dev) | `^5.0.1` | **Fixed (F1)** — `node_modules` resynced to match the lockfile. |
| `sharp` (dev) | `>=0.35.0` | **Fixed (F1)** — resynced to `0.35.3`. |
| `del` (dev) | `~8.0.1` | OK |
| `require-dir` (dev) | `~1.2.0` | OK |
| `fast-glob` (dev) | `^3.3.3` | Added as part of P3 (see below). |
| ~~`gulp-sharp-responsive`~~ | — | **Removed (P3)** — see below. |

`npm audit` reports **0 vulnerabilities** as of the P3 change (2026-08-11), down from 3 high-severity findings.

**`gulp-sharp-responsive` — replaced, not just resynced**: this private-git-fork dependency (`git+ssh://git@github.com/willinteractive/gulp-sharp-responsive.git`) turned out to be broken under `gulp@5.0.1` (the `generate-responsive-images` task hung indefinitely — see [01-npm-dependency-resync.md](specs/01-npm-dependency-resync.md)) and pinned its own vulnerable `sharp@^0.33.2` internally regardless of this repo's lockfile. It's been replaced with a direct `sharp` + `fast-glob` implementation in `gulp/responsiveImages.js` — no more third-party wrapper, no more SSH-gated install. See [09-replace-responsive-image-tool.md](specs/09-replace-responsive-image-tool.md).

## Upgrade ordering — status

1. ~~Fix local tooling drift~~ **Done (F1).**
2. ~~Pin `required_ruby_version`~~ **Done (F2).**
3. ~~Add an explicit floor to `rails`~~ **Done — raised to `>= 8.0`** (see Ruby/Rails table above; originally scoped as "add an upper bound," the team instead chose to raise the floor once `access`/`learning`'s modernization was confirmed as imminent).
4. **SCSS `@import` → `@use` migration** (22 call sites vs. 1 `@use` today) — still open. `dartsass-sprockets ~> 3.2` is already current; Dart Sass has deprecated `@import` and it will eventually be removed from the module system.
5. ~~`gulp-sharp-responsive` replacement~~ **Done (P3)**, re-prioritized after F1 revealed it was actively broken rather than just a someday risk.

No abandoned/unmaintained gems or npm packages remain among the currently declared dependencies.
