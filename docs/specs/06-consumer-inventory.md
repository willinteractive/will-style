# 06 — Inventory consuming apps (F6)

## Current State

Four apps consume will-style via git reference (no publish process exists): Launchpad, Access, Learning, Veils-Player, all in the `willinteractive` GitHub org. Their current will-style ref/tag, asset-pipeline mode (Sprockets-only vs importmap-rails), and Bootstrap version are unknown from this repo alone.

## Desired Outcome

A table recording, per app: will-style git ref/tag pinned in `Gemfile.lock`, Sprockets-only vs importmap-rails usage, Bootstrap major version, and Rails/Ruby version.

## Recommended Approach

For each of the four repos: check `Gemfile.lock` for the will-style revision; check for `config/importmap.rb` presence/usage vs. a Sprockets-only manifest; check the `Gemfile` for the Bootstrap and Rails versions. This is the direct prerequisite for [12](12-fontawesome-final-decision.md)... actually for [13-coordinate-7-0-release-schedule.md](13-coordinate-7-0-release-schedule.md) and [14-sprockets-removal-decision.md](14-sprockets-removal-decision.md) and [15-remove-sprockets-js-manifest.md](15-remove-sprockets-js-manifest.md) — don't let those proceed on assumptions.

## Risks and Tradeoffs

None — pure read-only investigation. Requires access to all four repos.

## Rollback Plan

N/A — investigation only, produces a document.

## Acceptance Criteria

A completed table with no blank cells for any of the four apps, reviewed by a human before it gates the items above.

## Dependencies

None.

## Estimated Complexity

Small.

## Coding Agent Safe?

Yes, if given read access to the four repos; otherwise a human needs to pull the info.

## Outcome (2026-08-11)

All four repos were locally available and inspected directly (`~/Developer/rails/{launchpad,access,learning}`, `~/Developer/html5/veils-player`).

| App | Type | will-style pin | Rails | Ruby | Asset pipeline |
|---|---|---|---|---|---|
| **launchpad** | Rails engine consumer | `will_style` `6.0.1` (gem, underscore name) | `8.1.3.1` | `3.4.10` (`.ruby-version`) | `config/importmap.rb` present — on importmap-rails |
| **access** | Rails engine consumer | `will-style` `5.1.5` (gem, **hyphenated** name) | `6.1.7.9` | `3.2.2` (`.ruby-version`) | No `config/importmap.rb` found — likely Sprockets-only |
| **learning** | Rails engine consumer | `will-style` `5.1.5` (gem, **hyphenated** name) | `6.1.7.10` | `3.2.2` (`.ruby-version`) | No `config/importmap.rb` found — likely Sprockets-only |
| **veils-player** | Plain HTML5/JS app (not Rails) | `will-style` `6.0.3` (**npm**, `git+https://...#6.0.3`) | N/A | N/A | Consumes the npm/node SCSS context (`core/will_icons/_node.scss` path) only — no Rails asset pipeline involved at all |

**Findings that change the picture from the original open-questions answers:**

1. **`access` and `learning` are two majors behind** (`5.1.5` vs. current `6.0.3`) and predate the gem's rename from `will-style` to `will_style` (commit `efc7efe`, 2025-12-19, first released as `6.0.0`). Upgrading either app past `5.1.5` requires changing their `Gemfile`'s gem name (`'will-style'` → `'will_style'`), not just bumping a version string.
2. **`access` and `learning` are on Ruby `3.2.2`** — below the `>= 3.4.10` floor just shipped in [02-ruby-version-floor.md](02-ruby-version-floor.md) (F2). This doesn't break anything today since both are pinned to old tags, but **neither app can adopt any future will-style release built after F2 until it upgrades its own Ruby first.** That's a real prerequisite for the `7.0` rollout ([13-coordinate-7-0-release-schedule.md](13-coordinate-7-0-release-schedule.md)), not a formality.
3. **`access` and `learning` are on Rails `6.1.7.x`**, not Rails 8 — this is a live snapshot, not necessarily their near-term plan, but it means the "all consumers migrating to Rails 8" premise behind leaving the `rails` gem dependency unbounded should be re-confirmed with whoever owns those two apps before the `7.0` rollout is scheduled.
4. **Neither `access` nor `learning` has `config/importmap.rb`** — [14-sprockets-removal-decision.md](14-sprockets-removal-decision.md) (B3) cannot green-light removing the Sprockets JS manifest until this is confirmed one way or the other with whoever owns those apps (they may be Sprockets-only, or on a pipeline this check didn't detect).
5. **`veils-player` isn't a Rails app at all** — it's a plain HTML5/JS project consuming will-style purely through npm, already on the current `6.0.3`. The entire Sprockets/importmap question (B3/C1) is irrelevant to it; what matters for this consumer is the npm package and the `_node.scss` consumption path staying stable.

This significantly changes the risk picture for the `7.0` rollout — `launchpad` is ready, `veils-player` is unaffected by the JS-loading work, but `access`/`learning` likely need their own Ruby/Rails upgrades as a **prerequisite**, not a parallel track. Recommend confirming current plans with whoever owns `access`/`learning` before finalizing the `B2` schedule.
