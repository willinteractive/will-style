# 14 — Decide Sprockets manifest removal timing (B3)

## Current State

`app/javascript/will_style.js` (a Sprockets `//= require` manifest) and `config/importmap.rb` (`pin_all_from`) both currently serve the same 18 JS files. Whether any consumer still depends on the Sprockets-only path is unknown until [06-consumer-inventory.md](06-consumer-inventory.md) is complete.

## Desired Outcome

A clear go/no-go on removing `app/javascript/will_style.js`.

## Recommended Approach

If spec 06 shows all four consumers are already on importmap-rails, proceed straight to [15-remove-sprockets-js-manifest.md](15-remove-sprockets-js-manifest.md). If any consumer is Sprockets-only, either get that consumer onto importmap-rails first (as its own prerequisite outside this repo) or keep both loading paths longer than planned and revisit this decision later.

## Risks and Tradeoffs

Removing the manifest while a consumer still needs it breaks that app's JS entirely, silently — there's no test coverage in the consumer apps to catch it either.

## Rollback Plan

N/A — this spec is the decision gate itself, not an implementation.

## Acceptance Criteria

A documented yes/no per consuming app, with a named remediation plan for any "no."

## Dependencies

[06-consumer-inventory.md](06-consumer-inventory.md).

## Estimated Complexity

N/A.

## Coding Agent Safe?

No — human decision based on spec 06's findings.
