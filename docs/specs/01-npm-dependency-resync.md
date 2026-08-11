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

- `npm ls` reports zero `invalid` entries. **Done** — `node_modules` now matches the lockfile (`gulp@5.0.1`, top-level `sharp@0.35.3`).
- `npx gulp generate-responsive-images` completes successfully against a sample image dropped in `src/`. **Not met** — see Outcome below.
- No `sharp`/libvips advisory shows up for the installed version. **Partially met** — see Outcome below.

## Outcome (2026-08-11)

Resync completed as planned, but surfaced two problems that weren't visible while `node_modules` was stale:

1. **`generate-responsive-images` hangs/errors** ("Did you forget to signal async completion?") once run against the now-current `gulp@5.0.1`. Debug tracing shows `gulp-sharp-responsive` does process the image and computes output filenames (confirmed via `DEBUG=*`), but the stream never reaches `gulp.dest("dist")` — nothing is written to `dist/`. This did not surface earlier because `node_modules` had been stale (`gulp@4.0.2`) since before this bug could have been hit, so it's unclear whether this task has actually run successfully since the `sharp` bump in `e66fa14`. Root cause is very likely `gulp-sharp-responsive` itself not being fully gulp-5-compatible (its own stream handling), not anything in this repo's `gulp/responsiveImages.js`.
2. **`gulp-sharp-responsive` pins its own `sharp` dependency at `^0.33.2`** (see its `package.json`), which can't dedupe with the top-level `sharp@0.35.3` — so a second, vulnerable, nested `sharp@0.33.5` gets installed regardless (`node_modules/gulp-sharp-responsive/node_modules/sharp`). `npm audit` still reports 3 high-severity findings (the inherited libvips CVEs, plus an `image-size` DoS advisory with no fix available), both scoped entirely inside `gulp-sharp-responsive`'s own dependency tree. **This cannot be fixed by `npm install` alone** — it requires either `gulp-sharp-responsive` bumping its own `sharp` pin, or replacing the tool.

Both problems point at the same place: [09-replace-responsive-image-tool.md](09-replace-responsive-image-tool.md) (P3) is no longer just "nice to have, not urgent" — the current tool is both broken under gulp 5 and carries an unfixable nested CVE. Recommend re-prioritizing P3 into the Foundation bucket, or at minimum doing it immediately after this item rather than deferring it. See updated note in `docs/MIGRATION.md`.

## Dependencies

None.

## Estimated Complexity

Trivial — one command plus a smoke test.

## Coding Agent Safe?

Yes — fully mechanical and easily verified.
