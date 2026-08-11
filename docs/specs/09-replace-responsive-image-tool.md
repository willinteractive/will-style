# 09 — Replace gulp-sharp-responsive (P3)

## Current State

`gulp-sharp-responsive` resolves via `git+ssh://git@github.com/willinteractive/gulp-sharp-responsive.git` to a single pinned commit (`066b452b`) — a single-maintainer WILL-owned fork, not published to the npm registry. Everyone currently has the SSH access needed to install it, so lack of access isn't an active blocker.

**Update (2026-08-11, from executing [01-npm-dependency-resync.md](01-npm-dependency-resync.md))**: this is more urgent than originally scoped. Once `node_modules` was resynced to match the lockfile (`gulp@5.0.1`), the `generate-responsive-images` task stopped completing — it hangs with "Did you forget to signal async completion?" and writes nothing to `dist/`, almost certainly because `gulp-sharp-responsive` itself isn't fully gulp-5-compatible. Separately, the package pins its own `sharp` dependency at `^0.33.2` in its `package.json`, which can't dedupe with this repo's `sharp@0.35.3` — so a second, CVE-vulnerable `sharp@0.33.5` installs nested inside it regardless of what this repo's own lockfile specifies (`npm audit` shows 3 high-severity findings scoped entirely inside `gulp-sharp-responsive`'s tree, with no fix available upstream). The tool is currently **broken under the versions this repo now requires**, not just a long-term maintenance risk.

## Desired Outcome

The `generate-responsive-images` gulp task runs on an actively maintained, registry-published package (or an in-house replacement with no third-party wrapper), preserving today's exact output.

## Recommended Approach

Evaluate registry alternatives that wrap `sharp` for responsive-image generation, or write a thin custom gulp task calling `sharp()` directly — `sharp` is already a direct dependency, so a hand-rolled loop over the six breakpoints could drop the third-party wrapper entirely and shrink the dependency surface to just `sharp` itself. Preserve the exact breakpoint set (540/768/960/1140/1320/1920px) and per-size JPEG/PNG/WebP quality settings currently defined in `gulp/responsiveImages.js`.

## Risks and Tradeoffs

Low risk to consumers — this tool only affects local/CI image generation, not the gem's shipped output (`src/`/`dist/` are gitignored). No longer low urgency, though: the tool doesn't currently work against the dependency versions this repo's own lockfile requires (see Current State), so this is closer to a bug fix than a modernization nice-to-have.

## Rollback Plan

Trivial — revert `gulp/responsiveImages.js` and `package.json` to the prior state.

## Acceptance Criteria

- `npx gulp generate-responsive-images` against the same sample image set produces equivalent output (same breakpoints, formats, comparable quality/file size).
- `npm install` succeeds for a contributor without SSH access to the private fork.

## Dependencies

None.

## Estimated Complexity

Medium.

## Coding Agent Safe?

Yes for the mechanical swap; a human should spot-check output quality/sizing against the current tool's output before merging.

## Outcome (2026-08-11)

Implemented. `gulp-sharp-responsive` is removed from `package.json`; `gulp/responsiveImages.js` now calls `sharp` directly (via `fast-glob` for source discovery, no vinyl/stream pipeline), preserving the exact breakpoint set (540/768/960/1140/1320/1920), per-size quality settings, WebP output, and the original tool's unsuffixed-1920/`-{width}`-suffixed-others naming convention. Smoke tested against sample PNGs (including a nested subdirectory) and an SVG: `generate-responsive-images` now completes (previously hung indefinitely post-F1), produces correctly-sized output at every breakpoint, and `npm audit` reports **0 vulnerabilities** (down from 3 high-severity, all previously nested inside `gulp-sharp-responsive`). No more `git+ssh` dependency — `npm install` now works for anyone regardless of repo access.
