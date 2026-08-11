# 01 — Resync npm dependencies (F1)

## Current State

`package.json` and `package-lock.json` already specify `gulp ^5.0.1`/`5.0.1` and `sharp >=0.35.0`/`0.35.3`, but the actually-installed `node_modules` has `gulp@4.0.2` and `sharp@0.33.5` (`npm ls` flags both as `invalid`). `sharp@0.33.5` is vulnerable to GHSA-f88m-g3jw-g9cj (libvips-inherited CVEs, CVSS 7, disclosed July 2026), patched in `0.35.0+`. This drift traces to commit `e66fa14 "Fixing sharp."`, which bumped the manifest/lockfile without a follow-up `npm install`.

## Desired Outcome

`node_modules` matches `package-lock.json` exactly; no CVE-vulnerable `sharp` binary installed locally or in CI.

## Recommended Approach

`rm -rf node_modules && npm ci` (or `npm install`) to resync from the existing lockfile — no manifest changes needed, this is purely a local-state fix. Confirm with `npm ls gulp sharp gulp-sharp-responsive` that no package reports `invalid`.

## Risks and Tradeoffs

`gulp` 5 has breaking changes from `gulp` 4 (task registration, promise-based completion), but `gulp/responsiveImages.js` already uses gulp 5-compatible syntax (ESM `import`, `gulp.series`) — so risk of the *code* breaking is low. The real risk is that this hasn't been smoke-tested since the lockfile bump, so the upgrade's actual behavior is unverified.

## Rollback Plan

Trivial — `node_modules` isn't tracked in git; re-running `npm install` against the current lockfile always reproduces a known state.

## Acceptance Criteria

- `npm ls` reports zero `invalid` entries.
- `npx gulp generate-responsive-images` completes successfully against a sample image dropped in `src/`.
- No `sharp`/libvips advisory shows up for the installed version.

## Dependencies

None.

## Estimated Complexity

Trivial — one command plus a smoke test.

## Coding Agent Safe?

Yes — fully mechanical and easily verified.
