# 04 — Stand up a Ruby test harness (F4)

## Current State

No `spec/` or `test/` directory exists. `Rakefile` defines only an `RDoc::Task`. No RSpec/Minitest dependency anywhere. Measured coverage: 0%.

## Desired Outcome

A runnable Ruby test suite — a dummy/combustion-style Rails host app plus a test framework — covering at minimum: the engine loads cleanly in a host app, the `will_style.importmap` initializer wires up correctly (map includes both host and engine `config/importmap.rb` entries, cache sweeper watches `app/javascript`), and `WillStyle::LibraryHelpers#icon` renders the expected markup.

## Recommended Approach

Use the standard Rails-engine testing pattern: a `test/dummy` (or `spec/dummy`) minimal Rails app that mounts the engine, generated via `rails plugin new`-style scaffolding or the `combustion` gem (which avoids committing a full dummy app to the repo). Add `rspec-rails` or `minitest` as a dev dependency — match whatever convention is already standard across WILL's other Rails apps (check Launchpad's test stack) rather than introducing a third convention into the org. Write initial smoke tests for the three areas above.

## Risks and Tradeoffs

Dummy-app test harnesses for Rails engines carry real boilerplate. The main tradeoff is time spent on harness setup vs. immediate test-writing — worth it here because every other spec in this roadmap depends on having a safety net before touching internals.

## Rollback Plan

Purely additive (new `test/`/`spec/` directory, new dev dependency, no production code touched) — fully reversible by deleting the directory.

## Acceptance Criteria

- `bundle exec rspec` (or `rake test`) runs and passes.
- Coverage includes: engine boots in the dummy app, importmap initializer wiring, and `LibraryHelpers#icon` output.

## Dependencies

None.

## Estimated Complexity

Medium.

## Coding Agent Safe?

Partially — initial scaffolding and smoke tests are agent-safe; the RSpec-vs-Minitest convention choice should be confirmed by a human against the team's existing standard first.
