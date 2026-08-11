# 07 — SCSS @import → @use migration (P1)

## Current State

58 SCSS partials under `lib/assets/stylesheets/will_style/` use the legacy `@import` directive 22 times vs. `@use` once (`elements/buttons/_overrides.scss:5`). `dartsass-sprockets ~> 3.2` runs on Dart Sass, which deprecates `@import` and will eventually remove it.

## Desired Outcome

All internal SCSS uses `@use`/`@forward` instead of `@import`, with no functional or visual change to compiled output in any consuming app.

## Recommended Approach

Convert one partial first as a pilot — pick a leaf-level file with few cross-file references — to confirm `dartsass-sprockets` handles `@use` module namespacing end-to-end. Pay special attention to the Bootstrap variable-override files (`_site.scss` and friends): `@use` scopes variables/mixins by namespace and doesn't leak them globally the way `@import` does, so Bootstrap variable overrides may need explicit `@forward ... show` or `with()` configuration to keep working — this is the most likely source of a silent visual regression. Once the pilot validates the approach, convert the rest in dependency order (leaves first, entry points like `will_style.scss` and `email.scss` last).

## Risks and Tradeoffs

The stricter scoping of `@use` is the core risk: a Bootstrap variable override that silently falls back to Bootstrap's default (instead of erroring) would ship a subtle visual regression across all four consuming apps with no test coverage to catch it. Mitigate with a compiled-CSS diff, not just "it compiles without errors."

## Rollback Plan

Land as one PR per stylesheet subdirectory (not one giant PR) so a broken partial can be reverted independently without unwinding the whole migration.

## Acceptance Criteria

- Compiled CSS output is visually identical before/after for a representative host app (diff via `sass` output or a visual regression check).
- `dartsass-sprockets` compilation produces zero `@import` deprecation warnings.

## Dependencies

[05-lint-and-ci.md](05-lint-and-ci.md).

## Estimated Complexity

Medium — mechanical, but touches nearly every stylesheet file.

## Coding Agent Safe?

Yes for the pilot and mechanical conversion; a human should specifically review the Bootstrap-variable-override files, where `@use` scoping most commonly causes silent visual regressions.

**Note**: don't run this concurrently with [08-remove-will-icons.md](08-remove-will-icons.md) — both touch `lib/assets/stylesheets/will_style/core/` and `mixins/`. Land 08 first.
