# 16 — Convert JS to real ES modules (C2)

## Current State

18 IIFE-style files under `app/javascript/will_style/` (core, features, components, forms) share a single global `window.WillStyle` namespace, established in `core/settings.js` and `core/events.js`, with an implicit load-order dependency and zero `import`/`export` syntax.

## Desired Outcome

Real ES modules with explicit `import`/`export`; no reliance on global load order or a shared `window.WillStyle` namespace.

## Recommended Approach

Convert `core/settings.js` and `core/events.js` first — they're the foundation every other file reads from — to export their values/functions explicitly. Then convert each feature/component/form file to `import` what it needs instead of reading `window.WillStyle.*`. Leave `vendor/growfield.js` as-is or wrap it minimally, since it's a vendored third-party UMD script, not one of ours to restructure. Update `config/importmap.rb` pins if any module paths change.

## Risks and Tradeoffs

This is the largest, most invasive change in the entire roadmap — it restructures every JS file's internals, not just its loading mechanism. Per `MIGRATION.md`'s concurrency rule, one engineer should own this continuously rather than splitting the file set across two people, since intermediate mixed-module-system states are hard to reason about jointly.

## Rollback Plan

Ship as part of the coordinated 7.0 release ([17](17-cut-7-0-release.md)) — if issues surface post-rollout, revert the affected consumer's pin to the pre-7.0 tag rather than attempting a partial in-repo rollback.

## Acceptance Criteria

- Zero IIFE-style files remain under `app/javascript/will_style/`.
- All behaviors verified working in each of the four consuming apps.
- No global `window.WillStyle` reads remain outside a documented, deliberate compatibility shim (if one is needed for a transition period).

## Dependencies

[15-remove-sprockets-js-manifest.md](15-remove-sprockets-js-manifest.md).

## Estimated Complexity

Large.

## Coding Agent Safe?

Partially — mechanical file-by-file conversion is agent-safe, but a human should own the overall sequencing and the final cross-app verification given the size of the blast radius.

## Outcome (2026-08-11)

Converted all 20 behavior files (repo actually has 20, not 18 as originally surveyed — `vendor/growfield.js` left untouched per the Recommended Approach, it's third-party UMD). Surveyed every `window.WillStyle.*` read/write first (`grep -rn "window\.WillStyle"`) before touching anything, to catalog the real shared-state surface rather than guess: it was small — `Settings` (a static config object), `Events.trigger`/`Events.on` (a `CustomEvent`-based pub/sub bus), and `Forms.initializeExpandingTextareas` (write-only from other files' perspective; nothing else in this repo calls it).

`core/settings.js` and `core/events.js` converted first (per the Recommended Approach), now `export`ing `Settings`/`trigger`/`on` for the other 18 files to `import`. Every other file: IIFE wrapper removed (redundant under real modules — each file already gets its own scope), `'use strict'` removed (implicit), internal logic otherwise untouched, `window.WillStyle.X.Y` reads replaced with the imported binding.

**Deliberate deviation from a hard break**: found one real external consumer of `window.WillStyle` outside the 20-file module graph — `app/views/will_style/components/_deferred_styles.html.erb` has an inline `<script>` (runs before the module graph, as part of an anti-FOUC preload/onload handler) that polls `window.WillStyle.Events` directly to fire `css-initialized`. That alone forces `Events` to stay a real global. Rather than treating `Settings` and `Forms.initializeExpandingTextareas` differently (no confirmed reader found for either, only in this repo) I kept all three as compatibility-shim globals, on the judgment that the downside of an unverifiable guess (a consuming app's own JS reading `window.WillStyle.Settings.pageChangeEvent`, or manually re-triggering `Forms.initializeExpandingTextareas` after an AJAX form injection, are both plausible integration patterns) outweighed the cleanliness of removing them. This is exactly the "documented, deliberate compatibility shim" the acceptance criteria anticipated — not a half-finished conversion.

`config/importmap.rb` needed no changes — same file paths, same `pin_all_from`-generated names, so the `import "will_style/core/settings"` etc. statements resolve identically to before.

**Verified from this repo**: `npm run lint:js` clean (repo-wide `sourceType: "module"` now in `eslint.config.mjs`, same 10 pre-existing unrelated warnings, zero new ones); `node --check` on all 21 files (20 behavior files + the `will_style.js` entry point) after copying to `.mjs` to force module parsing; `bundle exec rspec`/`rubocop`/`gem build` all clean.

**Not verified — acceptance criteria not fully met, and the gap is larger than C1's**: "all behaviors verified working in each of the four consuming apps." This was a full internal rewrite of 20 files' logic — mechanical (careful 1:1 translation, nothing reordered or altered beyond the described changes) but large, so even though every line was traced back to its original behavior, this needs real browser verification before it ships to any consumer. No access to Launchpad/Access/Learning/Veils-Player from this repo to do that. Flagging this explicitly, same as [15](15-remove-sprockets-js-manifest.md): someone with access to a running consumer needs to exercise dropdowns, modals, navbar, pop-outs, forms (required-inputs, expanding-textareas, url-formatting, file-sizes, selected-buttons), animated/spannable/overlapped elements, and image/video backgrounds — checking for console errors and comparing visible behavior to the pre-C1/C2 baseline — before this is genuinely done.
