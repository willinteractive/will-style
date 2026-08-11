# 11 — FontAwesome pinned-package spike (P5)

## Current State

FontAwesome is loaded via a hardcoded Kit script with an embedded account token (`app/views/will_style/libraries/_fontawesome.html.erb:1`): `<script src="https://kit.fontawesome.com/952987fa81.js" crossorigin="anonymous">`. The team reports prior issues attempting a pinned-package approach; specifics aren't captured anywhere in this repo.

## Desired Outcome

A documented, evidence-based recommendation — adopt a pinned package, or confirm the Kit-script fallback — so this doesn't get re-litigated blind next time someone looks at it.

## Recommended Approach

This is a research spike, not a code change. Investigate `@fortawesome/fontawesome-free` (or the Pro equivalent, if WILL has a paid FontAwesome plan) as an importmap-pinned alternative. Specifically confirm whether the current Kit token implies a Pro subscription with icons unavailable in the free npm package — that licensing mismatch is the most likely root cause of "we had issues before," and should be confirmed before re-attempting rather than re-discovered the hard way.

## Risks and Tradeoffs

If WILL's FontAwesome plan is Pro-tier, the free package won't have icon parity, and a pinned approach may need a licensed package source (FontAwesome offers an npm registry with an auth token for Pro). Confirming licensing tier up front avoids repeating the earlier failure.

## Rollback Plan

N/A — this spike produces a recommendation, not a shipped change.

## Acceptance Criteria

A short written recommendation (go/no-go) exists, explicitly stating whether WILL's FontAwesome account tier supports a pinned-package approach.

## Dependencies

None.

## Estimated Complexity

Small.

## Coding Agent Safe?

Partially — the technical investigation is agent-safe, but confirming WILL's FontAwesome account/licensing tier needs a human with account access.
