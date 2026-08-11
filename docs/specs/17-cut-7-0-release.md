# 17 — Cut and roll out the 7.0 release (C3)

## Current State

All prior roadmap items have landed on `main` but the breaking changes (will-icons removal, Sprockets manifest removal, ESM conversion, raised Ruby floor) haven't been released or integrated into any consumer yet.

## Desired Outcome

will-style `7.0.0` is tagged and integrated into all four consuming apps per [13-coordinate-7-0-release-schedule.md](13-coordinate-7-0-release-schedule.md)'s schedule.

## Recommended Approach

Bump `lib/will_style/version.rb` and `package.json` to `7.0.0`. Write the `CHANGELOG.md` entry summarizing every breaking change (Sprockets manifest removed, JS converted to ES modules, will-icons removed, `required_ruby_version` raised to 3.4.10). Tag the release. Roll out to each consumer per the agreed order — one PR per consumer repo, monitored before moving to the next.

## Risks and Tradeoffs

This is the single highest-blast-radius event in the roadmap — it touches every production consumer at once (across the rollout window). Mitigated by everything upstream (test harness, CI, cross-app verification at [15](15-remove-sprockets-js-manifest.md)/[16](16-convert-js-to-esm.md)), but still warrants a slow, monitored, one-app-at-a-time rollout rather than a simultaneous bump everywhere.

## Rollback Plan

Per-consumer: revert that app's `Gemfile.lock` pin to the last `6.x` tag. will-style itself needs no in-repo rollback since old tags remain available via git reference.

## Acceptance Criteria

All four consuming apps running `7.0.0`, verified in production for at least one full traffic cycle each, with no rollback triggered.

## Dependencies

[15-remove-sprockets-js-manifest.md](15-remove-sprockets-js-manifest.md), [16-convert-js-to-esm.md](16-convert-js-to-esm.md), [13-coordinate-7-0-release-schedule.md](13-coordinate-7-0-release-schedule.md), [08-remove-will-icons.md](08-remove-will-icons.md).

## Estimated Complexity

N/A — release/rollout process, not a code change.

## Coding Agent Safe?

No — human-driven, monitored rollout.
