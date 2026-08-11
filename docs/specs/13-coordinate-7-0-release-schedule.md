# 13 — Coordinate the 7.0 release schedule (B2)

## Current State

No formal release/versioning process exists today — git tags bump with bare "Version bump." commit messages, there's no CHANGELOG, and no publish workflow. All four consuming apps (Launchpad, Access, Learning, Veils-Player) pull will-style via git reference.

## Desired Outcome

An agreed rollout order, schedule, and communication plan for cutting will-style `7.0` and integrating it into all four consuming apps without simultaneous multi-app breakage.

## Recommended Approach

Once [06-consumer-inventory.md](06-consumer-inventory.md) is complete and the breaking items ([08](08-remove-will-icons.md), [15](15-remove-sprockets-js-manifest.md), [16](16-convert-js-to-esm.md)) are ready, pick: a rollout order (lowest-risk/lowest-traffic consumer first is the conventional choice), a communication channel (a heads-up plus a per-consumer PR checklist), and a rollback trigger (what observed behavior means "revert this consumer's pin"). Add a `CHANGELOG.md` as part of this so the "why" behind 7.0 is documented for whoever integrates it per app.

## Risks and Tradeoffs

This is a coordination risk, not a code risk — the main failure mode is one app integrating 7.0 without understanding what changed (Sprockets manifest gone, will-icons gone, ESM JS) and breaking silently, since none of the consumer apps have test coverage for their will-style integration either.

## Rollback Plan

Per-consumer: since distribution is git-reference-based, rolling back one app is just re-pinning its `Gemfile.lock` to the prior tag.

## Acceptance Criteria

- A written rollout order and schedule exists and is shared with whoever owns each of the four apps.
- A `CHANGELOG.md` entry for `7.0` exists, summarizing every breaking change.

## Dependencies

[06-consumer-inventory.md](06-consumer-inventory.md).

## Estimated Complexity

N/A — process, not code.

## Coding Agent Safe?

No — this is a human scheduling and communication decision.
