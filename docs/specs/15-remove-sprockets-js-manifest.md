# 15 — Remove the Sprockets JS manifest (C1)

## Current State

Both `app/javascript/will_style.js` (Sprockets `//= require`, explicit load order: vendor → core → features → components → forms) and `config/importmap.rb` (`pin_all_from "../app/javascript/will_style"`, `pin "will_style"`) currently target the same 18 files.

## Desired Outcome

Only importmap-rails serves these files; the Sprockets manifest is removed.

## Recommended Approach

Delete `app/javascript/will_style.js`. Remove any corresponding `//= require will_style` reference from a consumer's own Sprockets manifest if [14-sprockets-removal-decision.md](14-sprockets-removal-decision.md) found one still relying on it. Confirm `config/importmap.rb`'s existing pins already cover the full file set (they do, per the system-map survey). Smoke test against each of the four consuming apps, exercising dropdowns, modals, navbar, and at least one form behavior.

## Risks and Tradeoffs

The 18 files are order-dependent IIFEs reading a global `window.WillStyle` namespace — this behaves differently under ESM's per-module execution (importmap-rails serves `<script type="module">`) than under Sprockets' straight concatenation. Even though full ESM conversion happens in [16](16-convert-js-to-esm.md), this step alone changes the loading mechanism and needs its own smoke test, not just "it compiles."

## Rollback Plan

Re-add the manifest file and its require directive; `git revert`.

## Acceptance Criteria

All 18 JS behaviors verified working in at least one real consuming app after the change; no console errors referencing `WillStyle` being undefined.

## Dependencies

[14-sprockets-removal-decision.md](14-sprockets-removal-decision.md), [04-ruby-test-harness.md](04-ruby-test-harness.md).

## Estimated Complexity

Medium.

## Coding Agent Safe?

Partially — the deletion itself is mechanical, but the cross-app smoke test needs a human or an agent with live access to a running consumer app.

**Note**: do not run concurrently with [16-convert-js-to-esm.md](16-convert-js-to-esm.md) — same 18 files, sequential steps. One engineer should own both in sequence.
