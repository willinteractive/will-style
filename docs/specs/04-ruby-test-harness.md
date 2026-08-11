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

## Outcome (2026-08-11)

Implemented, and the framework choice landed differently than originally scoped. Checking Launchpad (an *application*) suggested Minitest — but three other WILL-authored Rails **engine gems** checked out locally (`launchpad-integration`, `player-sync`, `will-session`) all consistently use **RSpec + Combustion + SimpleCov + `bundler-audit`**, with `launchpad-integration` also having a working `.github/workflows/ci.yml`. Since will-style is a gem, not an app, that's the more relevant precedent — matched it exactly rather than Minitest.

Added: `Gemfile` (gemspec + a `:test` group for `rspec-rails`, `simplecov`, `bundler-audit`), `combustion` as a gemspec dev dependency (`~> 1.5`, matching `player-sync`'s pattern), `.rspec`, `.ruby-version` (`3.4.10`, matching the new gemspec floor), `spec/spec_helper.rb`, `spec/rails_helper.rb` (`Combustion.initialize! :action_controller, :action_view` — no `:active_record`, since this gem has no models or database), and a minimal `spec/internal` dummy host app (`config/routes.rb`, `config/importmap.rb`, `app/assets/config/manifest.js` — required once Sprockets' railtie loads transitively via `dartsass-sprockets`/`bootstrap`).

Two spec files, 8 examples, all passing, 94.59% line coverage:
- `spec/helpers/will_style/library_helpers_spec.rb` — covers `LibraryHelpers#icon` (base rendering, extra classes, trailing text, the text/html_options argument-shuffling behavior).
- `spec/lib/will_style/engine_spec.rb` — covers the engine boots as an isolated `Rails::Engine`, `app/javascript` gets added to `config.assets.paths`, `WillStyle.importmap` builds correctly, and `WillStyle.gem_path` resolves to a real directory (with a note that despite the name it resolves to `lib/`, not the repo root — a pre-existing quirk, out of scope here per [03-remove-dead-code.md](03-remove-dead-code.md)'s decision to leave `gem_path` alone).

Required Bundler `4.0.18` (`gem install bundler -v 4.0.18`) to satisfy the `bundler ~> 4.0` dev dependency already in the gemspec — this wasn't a new constraint, just the first time anything actually exercised it locally.
