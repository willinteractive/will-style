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

## Outcome (2026-08-11) — partially resolved, blocked on account access

**Confirmed**: the team's Kit is **Pro-tier** (confirmed directly during P2's work, when the same question came up for the pagination-arrow replacement — see [08-remove-will-icons.md](08-remove-will-icons.md)). This most likely explains "we had issues before": `@fortawesome/fontawesome-free` on the public npm registry has no Pro icon parity, so any earlier attempt to pin that package would have silently dropped every Pro-only icon in use.

**Still blocked**: FontAwesome's Pro packages (`@fortawesome/pro-solid-svg-icons`, `@fortawesome/fontawesome-pro`, etc.) are distributed through FontAwesome's own private npm registry, gated by a per-account auth token generated from the FontAwesome dashboard. This isn't something inspectable or installable from this environment — it needs a human with dashboard access to (a) confirm the account actually supports npm/pinned-package distribution (some Pro tiers are Kit-only), (b) generate the registry auth token, and (c) decide how that token gets distributed to contributor machines/CI (an `.npmrc` secret, most likely) without leaking it into the repo.

**Recommendation**: don't block the rest of the modernization roadmap on this — it's an account/credentials task, not an engineering one. [12-fontawesome-final-decision.md](12-fontawesome-final-decision.md) (B1) should stay open until someone with FontAwesome dashboard access can answer the three points above; the Kit script remains the working fallback in the meantime.

## Resolution (2026-08-11)

Closed without pursuing the pinned package further. Asked the person with FontAwesome dashboard access to confirm the three blocking points above; rather than checking plan tier and token-distribution mechanics, the explicit call was to keep the Kit script — it's the simplest integration across all four consuming apps (a Rails engine gem, two Rails apps on older stacks, and `veils-player`, which isn't a Rails app at all), and a pinned package would need per-app importmap/bundler wiring that the Kit's single `<script>` tag avoids entirely. See [12-fontawesome-final-decision.md](12-fontawesome-final-decision.md) for the closure.
