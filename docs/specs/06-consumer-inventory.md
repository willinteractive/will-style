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
