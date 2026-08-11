# 02 — Set required_ruby_version (F2)

## Current State

`will_style.gemspec` declares no `required_ruby_version`. No `.ruby-version` file exists at the repo root either. As of 2026-08-11, `3.4.10` is the latest Ruby 3.4.x patch (released 2026-06-30; 3.4 is supported through 2028-03-31).

## Desired Outcome

`will_style.gemspec` declares `s.required_ruby_version = ">= 3.4.10"`.

## Recommended Approach

Add the line to `will_style.gemspec` alongside the other metadata (near `s.license`). Cross-check against [06-consumer-inventory.md](06-consumer-inventory.md)'s findings before shipping a version bump that includes this — if any consumer is on Ruby < 3.4.10, this floor would break their `bundle install` the moment they pick up the new will-style version.

## Risks and Tradeoffs

Low risk given all four consuming apps are reportedly migrating to Rails 8, which itself pushes toward a recent Ruby. The only failure mode is shipping this floor before confirming consumer Ruby versions.

## Rollback Plan

Revert the gemspec line; re-tag if already released.

## Acceptance Criteria

- `gem build will_style.gemspec` succeeds.
- Installing under Ruby < 3.4.10 fails fast with a clear Bundler version-constraint error.
- Installing under Ruby >= 3.4.10 succeeds normally.

## Dependencies

None to author; [06-consumer-inventory.md](06-consumer-inventory.md) recommended before shipping.

## Estimated Complexity

Trivial.

## Coding Agent Safe?

Yes.

## Outcome (2026-08-11)

Implemented — `s.required_ruby_version = ">= 3.4.10"` added to `will_style.gemspec`. `gem build will_style.gemspec` succeeds (build itself doesn't enforce the floor; it's enforced at install time by Bundler/RubyGems). Not yet cross-checked against consumer Ruby versions — still pending [06-consumer-inventory.md](06-consumer-inventory.md).
