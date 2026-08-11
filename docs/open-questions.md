# Open Questions — will-style

All 12 questions below have been answered (2026-08-11). Answers are recorded inline and now drive `MIGRATION.md`.

## Distribution & consumers

1. **How is will-style actually distributed to consuming apps?**
   **Answer**: Git reference (no RubyGems/npm publish process exists or is planned).
2. **Which apps consume this gem, and are any of them pinned to an old version or a different Bootstrap major?**
   **Answer**: Four apps, all in the `willinteractive` GitHub org: **Launchpad, Access, Learning, Veils-Player**. No stated pin/version outliers — treat all four as needing verification before any breaking release.

## Icon font (Fontastic)

3. **Does anyone on the team still have access to Fontastic (fontastic.me)?**
   **Answer**: No — access is lost. Decision: **remove `will-icons` entirely** rather than rebuild the pipeline; it's confirmed unused. This is a deletion item, not a modernization item.

## JS asset loading

4. **Is the dual Sprockets-manifest / importmap setup intentional, or an incomplete migration?**
   **Answer**: Incomplete migration — finish it. Drop the Sprockets manifest (`app/javascript/will_style.js`) and standardize on importmap-rails, after confirming (open item in `MIGRATION.md`) that none of the four consumers still depend on the Sprockets-only path.

## Third-party/external dependencies

5. **`gulp-sharp-responsive` private git fork — access and replacement?**
   **Answer**: Everyone currently has SSH access, so it's not an active blocker — but replace it with an actively maintained responsive-image tool as non-urgent cleanup.
6. **FontAwesome Kit script — keep, or move to a pinned package?**
   **Answer**: There's prior history of issues with the pinned-package approach. Spike on moving to a pinned package first; if it doesn't pan out, the hardcoded Kit script is an acceptable fallback.
   **Update 2026-08-11**: confirmed the account is Pro-tier (likely explaining the earlier trouble — `@fortawesome/fontawesome-free` has no Pro icon parity). A pinned-package spike is blocked on FontAwesome dashboard access to generate a private-registry npm auth token — needs someone with account access to pick this up; see [specs/11](specs/11-fontawesome-pinned-package-spike.md).
7. **`premailer-rails` — declare it as a dependency?**
   **Answer**: Yes — make it an **optional** declared dependency rather than a README-only note.

## Code health

8. **`WillStyle.stylesheets_path` dead code — delete or fix?**
   **Answer**: Delete it (confirmed no known callers).

## Versioning strategy

9. **How far should the `rails` dependency track?**
   **Answer**: Leave unbounded above the floor; revisit only if a future Rails 9 changes import/dependency structure in a way that breaks this gem.
   **Updated 2026-08-11**: after F6's consumer inventory showed `access`/`learning` still on Rails 6.1.x, the team confirmed those two are being modernized next — so it's fine to raise the floor itself to `>= 8.0` now (done, see [dependency-audit.md](dependency-audit.md)). This is a deliberate forcing function: neither app can adopt a will-style release built after this change until it's on Rails 8, which is expected to happen as part of their own modernization, not a surprise.
10. **Appetite for a breaking will-style major version?**
    **Answer**: Yes — breaking changes are fine as long as the rollout across the four consuming apps is coordinated (a 7.0 release, not a silent 6.x change).

## Lint tooling (raised 2026-08-11 during F5)

11. **Should will-style adopt Rubocop/Stylelint/ESLint?** None of the three other WILL-authored Rails-engine gems have any lint config.
    **Answer**: Add it anyway — done. Rubocop, Stylelint, and ESLint are all configured and clean (see [dependency-audit](dependency-audit.md) and [specs/05](specs/05-lint-and-ci.md)).

## Duplicate `stretch` mixin (found 2026-08-11 while adding Stylelint)

12. **`lib/assets/stylesheets/will_style/mixins/_layout.scss` defines `@mixin stretch` twice** — once with offset parameters (`position: absolute` + top/right/bottom/left), and again with no parameters (`min-height: 100vh`/`100dvh`), which silently shadowed the first.
    **Answer (2026-08-11)**: delete the offset-based version as dead code. No caller of it was found in this repo (only the bare, viewport-height form is used, three times in `components/_navbar.scss`); accepted the residual risk that a downstream consumer's own SCSS could theoretically call the offset form, per the standing dead-code policy in [standards.md](standards.md) (surfaces as a real break, gets reverted and documented, rather than left "just in case"). Done — see `mixins/_layout.scss`.
