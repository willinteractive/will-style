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
