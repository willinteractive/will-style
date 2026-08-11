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

## Outcome (2026-08-11)

**Recommended approach adjusted mid-implementation.** "Delete `app/javascript/will_style.js`" turned out to be unsafe as literally stated: `config/importmap.rb` pins the name `"will_style"` to that exact file with `preload: true` — the aggregate entry point consuming apps' own JS almost certainly imports (`import "will_style"`; nothing in this repo's `Readme.md` documents the contract, but `preload: true` on a single named pin, alongside 21 individually-pinned files nothing else references, points to this being the real one). Deleting the file outright would leave that pin resolving to nothing, breaking every consumer's entrypoint at once rather than just removing Sprockets.

Instead: kept the file at the same path (so the `"will_style"` pin keeps resolving) but rewrote its contents — Sprockets `//= require` directives replaced 1:1 with plain ESM side-effect `import` statements against the individual `pin_all_from`-generated names (`will_style/core/settings`, etc.), same 21 files, same order (vendor → core → features → components → forms preserved exactly, since `core/settings.js`/`core/events.js` establish `window.WillStyle` before anything else reads it). This removes the actual thing item C1 was about — dependency on Sprockets' `//= require` directive processor — without changing the public `import "will_style"` contract or touching any of the 21 files' internals (that's [16](16-convert-js-to-esm.md)'s job).

`eslint.config.mjs` updated: `app/javascript/will_style.js` now gets its own config block with `sourceType: "module"` (the other 20 files stay `sourceType: "script"` until C2 converts them).

**Verified from this repo**: `node --check` confirms valid ES module syntax; `npm run lint:js` clean (same pre-existing warnings only, no new ones); `bundle exec rspec`/`rubocop`/`gem build` all clean.

**Not verified — acceptance criteria not fully met**: "all 18 JS behaviors verified working in at least one real consuming app... no console errors referencing WillStyle being undefined." This repo has no access to Launchpad/Access/Learning/Veils-Player to run that smoke test. Flagging this explicitly rather than claiming done: someone with access to a running consumer needs to pull this change and check dropdowns/modals/navbar/at least one form behavior in a browser before/as part of the B2 rollout (Launchpad first, 2026-08-11).
