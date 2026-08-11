# 03 — Remove dead/broken code in the engine (F3)

## Current State

`lib/will_style/engine.rb:41-43` defines `WillStyle.stylesheets_path`, which calls `assets_path` — a method never defined anywhere in this file or module. Calling it raises `NoMethodError`. A repo-wide grep found no callers. `WillStyle.gem_path` (`engine.rb:37-39`) is defined but also has no callers found in this repo — it's a public method on the gem's namespace, so an external consumer *could* theoretically call it, which this repo alone can't rule out. Line 29's comment ("Using bootstrap-sass initialization") is stale — the code no longer touches bootstrap-sass.

## Desired Outcome

`stylesheets_path` is removed (confirmed dead, and broken as written regardless). The stale comment is removed. `gem_path` is left in place pending the consumer-usage check below, since deleting a public method with unknown external callers is riskier than deleting one that's provably broken.

## Recommended Approach

Delete `stylesheets_path` and the line-29 comment now. Note `gem_path` as a candidate for a follow-up deletion once [06-consumer-inventory.md](06-consumer-inventory.md) or a grep across the four consuming apps confirms it's unused externally too.

## Risks and Tradeoffs

Essentially zero — `stylesheets_path` already raises an exception on every call, so nothing "working" can regress.

## Rollback Plan

Trivial `git revert`.

## Acceptance Criteria

- `grep -rn "stylesheets_path" lib/` returns no hits.
- The gem still loads cleanly (`ruby -e "require './lib/will_style'"` or equivalent smoke test) with no error.

## Dependencies

None.

## Estimated Complexity

Trivial.

## Coding Agent Safe?

Yes.

## Outcome (2026-08-11)

Implemented — `stylesheets_path` and the stale "Using bootstrap-sass initialization" comment removed from `lib/will_style/engine.rb`. `gem_path` left in place per the original recommendation (no known callers here, but its public-method status means an external caller can't be fully ruled out from this repo alone). `ruby -c` syntax check and a full `gem build` both pass; no remaining references anywhere in the repo.
