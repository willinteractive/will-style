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

## Outcome (2026-08-11) — partially implemented, scope question raised

The CI half is done, matching real precedent rather than the originally-guessed scope: none of the three sibling WILL Rails-engine gems checked (`launchpad-integration`, `player-sync`, `will-session`) have **any** Rubocop/ESLint/Stylelint config — their actual convention is RSpec + `bundler-audit` + GitHub Actions, nothing more. Added `.github/workflows/ci.yml` mirroring `launchpad-integration`'s exact working workflow (an `rspec` job and a separate `bundler-audit` job, both using `ruby/setup-ruby` with `bundler-cache: true`). `bundle exec bundle-audit check --update` currently reports **0 vulnerabilities**.

**Not done**: Rubocop/Stylelint/ESLint themselves. This was the original ask from `modernization-prompt.md`'s Phase 3 topic list ("improving code quality and consistency"), but it would be net-new tooling for the org's Rails-engine gems, not a matched convention like everything else implemented so far. Flagged back to the team rather than deciding unilaterally — see the open question this raised in `docs/open-questions.md`.
