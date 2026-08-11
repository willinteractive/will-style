# will-style Modernization — Roadmap

Informed by [system-map.md](system-map.md), [dependency-audit.md](dependency-audit.md), [risk-notes.md](risk-notes.md), and the resolved [open-questions.md](open-questions.md). Items are tagged `Foundation` / `Parallel-safe` / `Blocked` per bucket rather than assigned named owners — self-assign from the `Parallel-safe` bucket as you go.

**Consumers to keep in mind throughout**: Launchpad, Access, Learning, Veils-Player (all git-referenced, no publish process). Any item that changes runtime JS/CSS output needs verification against all four before it's considered done.

## Sequencing logic

Lowest blast radius first (`F1`–`F3`), then the safety net (`F4`–`F6`) before anyone touches internals, then one pass of the most-repeated pattern (`P1`'s pilot file) before parallelizing the rest, then the tangled/least-understood/highest-coupling area — JS asset loading (`C1`–`C2`) — last, folded into the coordinated `7.0` release (`B2`/`C3`) once everything else has landed.

## Foundation — must complete before anything else

| ID | Title | Depends on | Complexity |
|---|---|---|---|
| F1 | Run `npm install` to resync `node_modules` with the lockfile — fixes the `gulp` version drift and, more importantly, the installed `sharp@0.33.5` CVE exposure (GHSA-f88m-g3jw-g9cj). Do this immediately, independent of everything else. | — | Trivial |
| F2 | ~~Set `required_ruby_version = ">= 3.4.10"`~~ **Done 2026-08-11.** See [docs/specs/02](specs/02-ruby-version-floor.md). | — | Trivial |
| F3 | ~~Delete `WillStyle.stylesheets_path`~~ **Done 2026-08-11.** `gem_path` left in place pending a consumer-usage check. See [docs/specs/03](specs/03-remove-dead-code.md). | — | Trivial |
| F4 | ~~Stand up a Ruby test harness~~ **Done 2026-08-11.** RSpec + Combustion, matching the org's other Rails-engine gems (not Minitest, which is what the *consuming apps* use — gems and apps turned out to have different conventions). 8 examples, 94.59% coverage. See [docs/specs/04](specs/04-ruby-test-harness.md). | — | Medium |
| F5 | Add lint config (Rubocop, Stylelint, ESLint) and a GitHub Actions CI workflow running lint + F4's tests. **Partially done 2026-08-11**: CI (RSpec + `bundler-audit`, 0 vulnerabilities) is live, matching real sibling-gem precedent. Linting itself is **not implemented** — none of the org's other Rails-engine gems have any lint config either, so this would be genuinely new tooling, not a matched convention. Needs a decision — see open questions. | F4 | Medium |
| F6 | ~~Inventory all four consuming apps~~ **Done 2026-08-11.** Found real surprises: `access`/`learning` are 2 majors behind on a pre-rename gem name, on Ruby 3.2.2 (below F2's new floor) and Rails 6.1.x, with no `config/importmap.rb`; `veils-player` isn't a Rails app at all. This changes `B2`/`B3`'s risk picture — see [docs/specs/06](specs/06-consumer-inventory.md). | — | Small |

## Parallel — either engineer, independent

| ID | Title | Depends on | Complexity |
|---|---|---|---|
| P1 | SCSS `@import` → `@use` migration. Convert **one partial first** as the pilot (per the repeated-pattern rule — confirm the approach works with `dartsass-sprockets` before scaling), then the remaining ~57 partials under `lib/assets/stylesheets/will_style/`. | F5 | Medium |
| P2 | Remove `will-icons` entirely: `will-icons/glyphs/`, `lib/assets/fonts/will-icons/`, `lib/assets/stylesheets/will_style/core/_will_icons.scss`, `core/will_icons/_rails.scss`, `_react.scss`, `_node.scss`, `mixins/_will-icons.scss`, the `@import` in `_core.scss`, the reference in `libraries/_will_paginate.scss`, and the usage in `app/views/will_style/components/_footer.html.erb`. Confirm no consuming app renders a `.will-icon-*` class before deleting (quick grep across the four repos). | F6 | Small |
| P3 | ~~Replace `gulp-sharp-responsive`~~ **Done 2026-08-11.** Re-prioritized after F1 revealed the tool was broken under `gulp@5.0.1` and carried a nested, unfixable CVE. `gulp/responsiveImages.js` now calls `sharp` directly; `npm audit` is clean (0 vulnerabilities); no more private git+ssh dependency. See [docs/specs/09](specs/09-replace-responsive-image-tool.md). | F1 | Medium |
| P4 | Make `premailer-rails` an optional declared dependency in `will_style.gemspec` (e.g. via a documented `Gemfile` addition pattern or a soft/optional-dependency convention) instead of a README-only note. | — | Trivial |
| P5 | Spike: investigate a pinned FontAwesome package as a replacement for the hardcoded Kit script in `_fontawesome.html.erb`. There's prior history of trouble with the pinned approach — this is a research task with a go/no-go output, not a guaranteed swap. Feeds `B1`. | — | Small |

**Do not run P1 and P2 concurrently on separate branches** — both touch `lib/assets/stylesheets/will_style/core/` and `mixins/`. Land P2 (smaller, pure deletion) first, then start P1 on a clean tree to avoid merge conflicts on shared partials.

## Blocked on a decision

| ID | Title | Depends on | Complexity |
|---|---|---|---|
| B1 | Finalize the FontAwesome approach based on `P5`'s findings — adopt the pinned package, or confirm the Kit-script fallback and close this out. | P5 | Small |
| B2 | Schedule and coordinate the `7.0` breaking release across Launchpad, Access, Learning, and Veils-Player — rollout order, timing, communication. This is a scheduling call, not engineering work, but nothing in `C1`–`C3` ships until it's made. | F6 | — |
| B3 | Decide the removal timing for the Sprockets JS manifest based on `F6`'s findings — proceed once no consumer is confirmed Sprockets-only. | F6 | — |

## Core — tangled, business-critical, least understood: do last

| ID | Title | Depends on | Complexity |
|---|---|---|---|
| C1 | Remove `app/javascript/will_style.js` (the Sprockets manifest); rely solely on `config/importmap.rb`. Verify all 18 JS behaviors still load and initialize correctly in each of the four consuming apps. | B3, F4 | Medium |
| C2 | Convert the 18 IIFE files under `app/javascript/will_style/` to real ES modules with explicit `import`/`export`, removing the implicit load-order dependency on the global `window.WillStyle` namespace. Do this as one continuous effort by a single engineer — don't split the file set across two people, since intermediate states will have mixed module systems that are hard to reason about together. | C1 | Large |
| C3 | Cut the coordinated `7.0` release: bundles `C1`, `C2`, and any other breaking pieces (e.g. the `will-icons` removal in `P2` counts as breaking for any consumer still referencing those classes). Roll out per `B2`'s schedule. | C1, C2, B2, P2 | — |

**Do not run C1 and C2 concurrently** — same 18 files, sequential steps (remove the old loader, then convert the module system). One engineer should own both in sequence; the second engineer should be working from the `Parallel` bucket during this window.
