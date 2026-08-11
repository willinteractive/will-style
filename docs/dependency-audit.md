# Dependency Audit — will-style

Live version data pulled from rubygems.org and the npm registry on 2026-08-11.

## Ruby / Rails

| Item | Current | Target | Notes |
|---|---|---|---|
| `required_ruby_version` | **unset** (no floor in [`will_style.gemspec`](../will_style.gemspec)) | `3.4.10` (per modernization brief) | `3.4.10` is genuinely the latest 3.4.x patch as of 2026-08-11 (released 2026-06-30); Ruby 3.4 is supported through 2028-03-31. No `.ruby-version` file exists anywhere in the repo root. |
| `rails` | `>= 7.2.3` (unbounded — [`gemspec:18`](../will_style.gemspec#L18)) | Add an upper bound once a target is chosen | Latest is `8.1.3.1`. An unbounded floor lets a consuming app resolve any future major (9.x, whenever it ships) against this gem without warning — see [risk-notes.md](risk-notes.md). |

**Security note**: CVE-2026-66066 ("KindaRails2Shell," CVSSv4 9.5) is a critical Active Storage arbitrary-file-read/RCE vulnerability affecting Rails 7.2 before 7.2.3.2, 8.0 before 8.0.5.1, and 8.1 before 8.1.3.1, patched 2026-07-29. This gem does not use Active Storage itself, so it isn't directly exploitable through will-style — but the unbounded `rails >= 7.2.3` floor means will-style will happily install alongside a vulnerable consuming-app Rails version without any signal. Worth a note in `CLAUDE.md`/`standards.md` that consuming apps must be on a patched Rails, independent of this gem's own constraint. ([Rapid7 writeup](https://www.rapid7.com/blog/post/etr-kindarails2shell-cve-2026-66066-critical-arbitrary-file-read-and-possible-remote-code-execution-in-ruby-on-rails/))

## Gemspec runtime dependencies

| Gem | Constraint | Current resolved | Latest available | Maintenance |
|---|---|---|---|---|
| `bootstrap` | `~> 5.3` | 5.3.x | `5.3.8` | Active (last release 2026-01-11). Constraint already tracks latest. |
| `dartsass-sprockets` | `~> 3.2` | 3.2.x | `3.2.1` | Active (last release 2025-04-08). Constraint tracks latest. |
| `autoprefixer-rails` | `~> 10.4` | 10.4.x | `10.4.21.0` | Active (last release 2025-04-12). Constraint tracks latest. |
| `turbo-rails` | `~> 2.0` | 2.0.x | `2.0.23` | Active (last release 2026-01-29). Constraint tracks latest. |
| `importmap-rails` | `~> 2.2` | 2.2.x | `2.2.3` | Active (last release 2026-01-07). Constraint tracks latest. |
| `bundler` (dev) | `~> 4.0` | 4.0.x | `4.0.18` | Active (last release 2026-08-05). Constraint tracks latest. |

**Read**: every declared gem dependency's version constraint already tracks its current latest release — none of these are individually stale. The gem-side risk isn't outdated pins, it's the **unbounded `rails` floor** and the **absence of a `Gemfile.lock`** (there is no root `Gemfile`, so nothing pins the actual resolved dependency tree for local development/testing of this gem itself — every `bundle install` against it floats).

## npm dependencies

| Package | `package.json` wants | `package-lock.json` resolves | Actually installed in `node_modules` | Latest on npm | Status |
|---|---|---|---|---|---|
| `bootstrap` (runtime) | `~5.3.8` | 5.3.8 | 5.3.8 | 5.3.8 | OK |
| `gulp` (dev) | `^5.0.1` | 5.0.1 | **4.0.2** | 5.0.1 | **Drifted** — installed copy is a major version behind what's declared/locked. `npm ls` flags it invalid. |
| `sharp` (dev) | `>=0.35.0` | 0.35.3 | **0.33.5** | 0.35.3 | **Drifted, and security-relevant** — see below. |
| `del` (dev) | `~8.0.1` | 8.0.1 | (not independently checked; low risk, tiny utility) | 8.0.1 | Constraint tracks latest. |
| `require-dir` (dev) | `~1.2.0` | 1.2.0 | — | 1.2.0 | Constraint tracks latest. |
| `gulp-sharp-responsive` (dev) | git URL, no version pin | resolves to commit `066b452b` on `willinteractive/gulp-sharp-responsive` via `git+ssh://` | 0.4.1 | N/A (private fork, not on npm registry) | See risk notes — single point of failure, SSH-gated. |

**Security note on `sharp`**: versions of `sharp` prior to `0.35.0` inherit vulnerabilities from bundled `libvips` (GHSA-f88m-g3jw-g9cj, CVSS 7, disclosed July 2026). The `node_modules` copy currently installed is `0.33.5` — **vulnerable** — even though `package.json`/`package-lock.json` already require `>=0.35.0`/pin `0.35.3` (patched). This isn't a stale constraint, it's a stale `node_modules`: someone bumped the manifest/lockfile (commit `e66fa14 "Fixing sharp."`) without re-running `npm install`. Since this only affects the local dev image-resizing tool (not assets shipped in the gem), the blast radius is contributor machines/CI, not consuming apps — but it's a one-command fix (`npm install`) and should happen immediately regardless of the broader modernization timeline. ([Patchstack advisory](https://patchstack.com/database/npm/npm/sharp/vulnerability/npm-sharp-inherited-vulnerabilities-in-libvips-cve-2026-33327-cve-2026-33328-cve-2026-35590-cve-2026-35591))

**`gulp-sharp-responsive` supply-chain note**: this dependency isn't published to the npm registry at all — it's pulled via `git+ssh://git@github.com/willinteractive/gulp-sharp-responsive.git`, pinned to a specific commit. Anyone running `npm install` without SSH access to that private WILL-owned repo cannot install this project's dev dependencies. It's also a single-maintainer fork with no visible release/versioning process. See [open-questions.md](open-questions.md).

## Recommended upgrade ordering

1. **Fix local tooling drift now, independent of the modernization timeline**: run `npm install` to bring `node_modules` back in sync with the lockfile (resolves both the `gulp` version mismatch and the `sharp` CVE exposure). Lowest possible blast radius — affects only local/CI tooling, not shipped output.
2. **Pin `required_ruby_version = ">= 3.4.10"`** in the gemspec. No downstream risk — this only tightens a currently-nonexistent floor.
3. **Add an explicit upper bound to `rails`** (e.g. `>= 7.2.3, < 9`) once a decision is made on how far ahead this gem should track — see open questions.
4. **SCSS `@import` → `@use` migration** (22 call sites vs. 1 `@use` today) — do this after the above, since `dartsass-sprockets ~> 3.2` is already current and this is purely internal SCSS-authoring cleanup with no dependency-version driver forcing it yet, but Dart Sass has deprecated `@import` and it's disallowed in the module system long-term.
5. **`gulp-sharp-responsive` replacement or vendoring decision** — lowest urgency (dev-only tool, works today for anyone with repo access) but should be resolved before it becomes a blocker for a new contributor or a CI pipeline.

No abandoned/unmaintained gems or npm packages were found among the currently declared dependencies — the risk here is version drift and unset floors, not dead upstreams.
