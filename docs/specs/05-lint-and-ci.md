# 05 — Add lint config and CI (F5)

## Current State

No `.rubocop.yml`, `.eslintrc*`, or `.stylelintrc*` exists anywhere in the repo. No `.github/workflows` directory — no CI of any kind.

## Desired Outcome

Rubocop, Stylelint, and ESLint configured — ideally matching whatever configs WILL's other Rails apps (e.g. Launchpad) already use, for org-wide consistency rather than a fourth bespoke standard — plus a GitHub Actions workflow that runs lint and the [04](04-ruby-test-harness.md) test suite on every push/PR.

## Recommended Approach

Pull shared lint configs from an existing WILL app if one exists. Add `.github/workflows/ci.yml` running `bundle exec rubocop`, `npx stylelint`, `npx eslint`, and `bundle exec rspec` (or the chosen test command from spec 04).

## Risks and Tradeoffs

Turning on lint for the first time on a never-linted codebase typically surfaces a large initial violation count. Use `rubocop --auto-gen-config` (or equivalent grandfathering) to freeze existing offenses and enforce only on new/changed code, rather than blocking this item on a full retroactive cleanup.

## Rollback Plan

CI workflow and lint config files can be reverted or disabled trivially; none of this touches runtime code.

## Acceptance Criteria

- PRs show lint + test results in GitHub Actions.
- A deliberately introduced lint offense fails the CI check.

## Dependencies

[04-ruby-test-harness.md](04-ruby-test-harness.md).

## Estimated Complexity

Medium.

## Coding Agent Safe?

Yes for scaffolding; a human should review the initial grandfathered-violation list before merging.

## Outcome (2026-08-11) — fully implemented

CI (RSpec + `bundler-audit`) matches real sibling-gem precedent, mirroring `launchpad-integration`'s working `.github/workflows/ci.yml` exactly. `bundle exec bundle-audit check` reports **0 vulnerabilities**.

Rubocop/Stylelint/ESLint were flagged as new territory (no sibling WILL Rails-engine gem has any lint config) and the team explicitly chose to add them anyway rather than match the gap in precedent — see `docs/open-questions.md` #11.

- **Rubocop**: `.rubocop.yml` (Ruby 3.4 target, `rubocop-rails` plugin, 120-char line length, gemspec dev-dependency and RequireMFA cops disabled as intentional non-fits). Ran safe + unsafe autocorrect (`-a`, then `-A`) across the repo: 128 offenses → 0, all mechanical (string quoting, frozen-string-literal comments, freezing `VERSION`, gemspec dependency ordering). Verified tests still pass and the gem still builds after autocorrecting.
- **Stylelint**: `.stylelintrc.json` extends `stylelint-config-standard-scss`, with a deliberately curated set of disabled rules — some deferred to other roadmap items (`at-rule-no-deprecated`/`scss/no-global-function-names`, since `@import` and legacy Sass global functions are P1's territory, not this one), some genuinely not applicable here (`property-no-unknown` allows `mso-*` for the email partials' Outlook-compatibility properties; `font-family-no-missing-generic-family-keyword` disabled for the icon font). Ran `--fix`: 858 problems → 23 real ones. Fixed the safe/small ones directly: a duplicated `overflow-wrap: break-word;` line (`mixins/_type.scss`) and a function renamed to kebab-case (`will_style-bg-url` → `will-style-bg-url`, all 5 call sites updated — Sass treats `_`/`-` as equivalent in identifiers, so this was purely cosmetic). **Found and flagged, not silently fixed**: `mixins/_layout.scss` defines `@mixin stretch` twice with completely different signatures/behavior — the second silently shadows the first. Left an inline `stylelint-disable` comment pointing at the finding rather than guessing which behavior is intended; logged as `docs/open-questions.md` #12.
- **ESLint**: flat config (`eslint.config.mjs`, since ESLint 10 requires flat config) with separate rule sets for the browser IIFE files (`app/javascript/**`), the Node ESM gulp task, and CommonJS `gulpfile.js`; the vendored `growfield.js` is excluded from linting entirely (third-party code, not ours to rewrite). Fixed all 16 real errors: unnecessary regex escapes (verified behaviorally identical with a before/after sanity script across several sample inputs), unsafe `hasOwnProperty` calls rewritten to `Object.prototype.hasOwnProperty.call(...)`, and one dead `= 0` initializer. Left 10 `no-unused-vars` as non-blocking warnings (unused catch-block error params, a couple of genuinely-unused computed values) rather than touching logic in files with real runtime behavior for a lint-tooling task. `no-empty` disabled for the browser JS ruleset — `required-inputs.js` uses an intentional empty if-branch as an inverted-condition no-op, not a bug.
- Added `npm run lint` (`lint:js` + `lint:css`) and wired both into a new `lint-js-css` CI job alongside the existing `rspec`/`bundler-audit` jobs (now also `rubocop`, its own job).

Full verification pass after all changes: Rubocop clean, RSpec 8/8 passing (94.87% coverage), `bundler-audit` clean, ESLint 0 errors/10 warnings, Stylelint clean, gem still builds.
