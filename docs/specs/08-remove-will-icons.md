# 08 — Remove will-icons (P2)

## Current State

Fontastic (fontastic.me), the external tool that generated the compiled `will-icons` font, is no longer accessible to the team. The team has confirmed the font is unused. Files involved: `will-icons/glyphs/` (13 source SVGs), `lib/assets/fonts/will-icons/` (compiled `.eot`/`.svg`/`.ttf`/`.woff`), and eight references: `lib/assets/stylesheets/will_style/_core.scss`, `core/_will_icons.scss`, `core/will_icons/_rails.scss`, `_react.scss`, `_node.scss`, `mixins/_will-icons.scss`, `libraries/_will_paginate.scss`, and `app/views/will_style/components/_footer.html.erb`.

## Desired Outcome

All will-icons source assets, compiled font files, SCSS, and view references removed from the repo.

## Recommended Approach

Before deleting, grep all four consuming apps for `will-icon-` class usage as a belt-and-suspenders check on top of the team's "confirmed unused" answer. Then: delete `will-icons/glyphs/` and `lib/assets/fonts/will-icons/`; delete `core/_will_icons.scss`, `core/will_icons/_rails.scss`, `_react.scss`, `_node.scss`, and `mixins/_will-icons.scss`; remove their `@import`s from `_core.scss`; remove the reference in `libraries/_will_paginate.scss`; strip the icon markup from `_footer.html.erb`.

## Risks and Tradeoffs

If any consumer has a custom override that still renders a `.will-icon-*` class — invisible from this repo, and there's no test coverage in the consumer apps either to catch it — removal breaks that rendering silently. This is why the cross-app grep matters even though the team says it's unused.

## Rollback Plan

Straightforward `git revert` if the cross-app check turns up a live reference after the fact.

## Acceptance Criteria

- `grep -rn "will-icon\|will_icons" .` (excluding this spec) returns no hits.
- `_footer.html.erb` renders without error.
- Compiled CSS no longer includes a `will-icons` `@font-face` declaration.

## Dependencies

[06-consumer-inventory.md](06-consumer-inventory.md), or at minimum a targeted grep for `will-icon-` usage across the four consumer repos.

## Estimated Complexity

Small.

## Coding Agent Safe?

Yes, once the cross-app usage check confirms zero references.

**Note**: land this before [07-scss-import-to-use-migration.md](07-scss-import-to-use-migration.md) — both touch the same SCSS directories; don't run them concurrently.
