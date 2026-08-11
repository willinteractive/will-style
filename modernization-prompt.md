# WILL Style Modernization — Planning Prompt (DRAFT)

## Context

We are modernizing our web applications. We just finished a modernization task with our Launchpad, the Ruby on Rails application that serves as the authentication system at WILL Interactive. We are now going to tackle will-style, which is a gem that includes shared styles and scripts for web applications, both ruby on rails and standalone web packages build through node. Two engineers are working on this from separate machines, so the plan needs to be splittable.

## Your role

Act as a senior Rails architect and technical lead. This session is planning only — we are not implementing anything yet.

## Hard constraints

- **Read-only on application code.** Do not edit, refactor, upgrade, or "quickly fix" anything. The only files you may write are the planning artifacts named below.
- **This is a shared dependency bundled into multiple production apps** (Launchpad among them). A regression here doesn't lock anyone out — it ships broken or missing styles, broken JS behaviors, or broken transactional-email markup simultaneously to every consuming app, often silently, since there is no test suite to catch it. Treat cross-app compatibility, silent visual/behavioral regressions, and safe versioning/rollback for consumers as first-class constraints, not footnotes.
- **Ask rather than assume.** Interview me when you need product or architectural context that cannot be inferred from the code. Batch your questions into one round rather than drip-feeding them.

---

## Phase 1 — Survey, then stop

Scan the codebase and produce:

**`docs/system-map.md`**
Architecture overview, module and dependency graph, and the build & distribution flow end to end — SCSS source through compilation to delivery in a consuming app, JS asset loading and lifecycle, icon-font generation, and the local image-processing pipeline. Also cover: frontend approach, background jobs, external integrations, test strategy and actual measured coverage.

**`docs/dependency-audit.md`**
Current Ruby and Rails versions and the realistic target. Every gem with current version, latest version, and maintenance status. Known CVEs. Anything abandoned or blocking the upgrade path, and the order the upgrades have to happen in.

**`docs/risk-notes.md`**
Per area: business criticality, test coverage, coupling to the rest of the system, and how well-understood it appears to be.

**`docs/open-questions.md`**
Every behavior you found that you cannot explain from the code alone — undocumented business rules, load-bearing workarounds, code that looks dead but you're not certain. Do not guess and do not fill gaps with plausible assumptions. This is the most valuable file you will produce.

**Stop after Phase 1.** Present the survey and your questions, and wait for my answers before continuing.

---

## Phase 2 — Roadmap

After I answer your questions, produce **`docs/MIGRATION.md`** — the ordered work plan, as a table with: id, title, status, owner, depends-on, complexity.

Order by dependency and risk, not by the topic list below. Separate the work into:

- **Foundation** — must complete before anything else (version upgrades, test harness, CI)
- **Parallel** — either of us can pick these up independently
- **Blocked on a decision** — waiting on a call I need to make

Sequencing rules: lowest blast radius first; best-tested first; do one instance of a repeated pattern early so the lesson pays off across all the others; leave the tangled, business-critical, untested core for last.

Flag explicitly anything that two people should not work on simultaneously.

---

## Phase 3 — Specifications

One spec per work item, at `docs/specs/NN-name.md`. Cover these areas, but sequence them in `MIGRATION.md` rather than treating them as parallel tracks:

- Updating all dependencies including both in the gemspec and in the package.json
- Set a required ruby version of 3.4.10 for this gem
- Improving code quality and consistency
- Eliminating deprecated patterns and technical debt
- Increasing unit and integration test coverage
- Identifying security vulnerabilities and risky code
- Documenting the architecture and developer workflows
- Remove any outdated javascript libraries, like jQuery, if discovered
- Recommending modern Rails 8 best practices where appropriate


Each spec contains:

- Current state
- Desired outcome
- Recommended approach
- Risks and tradeoffs
- Rollback plan
- Acceptance criteria (testable, not aspirational)
- Dependencies — what must land first
- Estimated implementation complexity
- Whether this is safe to hand to a coding agent, or needs a human driving

---

## Also produce

**`CLAUDE.md`** — one page, no longer. Stack and versions, the exact build/test/lint commands (ours, not the conventional ones), the 3–5 directories that matter and what each does, conventions a linter can't enforce, and a "do not modify" list. Point to longer docs by path rather than inlining them.

**`docs/standards.md`** — target-state conventions. What modernized will-style code should look like when we're done, in enough detail that two different sessions weeks apart make the same choices.

---

## Judgment I want from you

- Challenge the existing architecture. Do not assume current patterns are correct because they're there.
- Where multiple approaches are viable, lay out the tradeoffs and recommend one.
- Treat the frontend question as a fork in the road that may block downstream work. Surface it early with a recommendation and an assessment of how reversible the choice is.
- Call out anything that should be deleted rather than modernized.
