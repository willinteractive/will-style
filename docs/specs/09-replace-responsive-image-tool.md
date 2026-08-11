# 09 — Replace gulp-sharp-responsive (P3)

## Current State

`gulp-sharp-responsive` resolves via `git+ssh://git@github.com/willinteractive/gulp-sharp-responsive.git` to a single pinned commit (`066b452b`) — a single-maintainer WILL-owned fork, not published to the npm registry. Everyone currently has the SSH access needed to install it, so it's not an active blocker, but it's a single point of failure with no visible release process.

## Desired Outcome

The `generate-responsive-images` gulp task runs on an actively maintained, registry-published package (or an in-house replacement with no third-party wrapper), preserving today's exact output.

## Recommended Approach

Evaluate registry alternatives that wrap `sharp` for responsive-image generation, or write a thin custom gulp task calling `sharp()` directly — `sharp` is already a direct dependency, so a hand-rolled loop over the six breakpoints could drop the third-party wrapper entirely and shrink the dependency surface to just `sharp` itself. Preserve the exact breakpoint set (540/768/960/1140/1320/1920px) and per-size JPEG/PNG/WebP quality settings currently defined in `gulp/responsiveImages.js`.

## Risks and Tradeoffs

Low risk — this tool only affects local/CI image generation, not the gem's shipped output (`src/`/`dist/` are gitignored). Main tradeoff is engineering time against a currently-working tool.

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
