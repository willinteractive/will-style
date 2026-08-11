# 12 — Finalize FontAwesome approach (B1)

## Current State

Depends entirely on [11-fontawesome-pinned-package-spike.md](11-fontawesome-pinned-package-spike.md)'s findings.

## Desired Outcome

The FontAwesome loading approach is finalized and implemented — either the pinned package replaces the Kit script, or the decision to keep the Kit script is explicitly documented and closed out.

## Recommended Approach

If spec 11 recommends the pinned package and licensing supports it: implement it (pin via `config/importmap.rb`, remove the `<script>` tag from `_fontawesome.html.erb`, update `LibraryHelpers#icon` if the class/markup conventions differ). If not: close this item as "keep Kit script," documenting why, so it isn't reopened without new information.

## Risks and Tradeoffs

If swapping, the main risk is any icon only available via the Kit's live-updating set not existing in the pinned package snapshot — verify against actual icon usage across all four consuming apps before merging.

## Rollback Plan

Revert to the Kit script if the pinned package proves incomplete post-swap.

## Acceptance Criteria

All FontAwesome icons currently rendered across the four consuming apps render identically after the change — or the decision to keep the status quo is documented and this item is closed without a code change.

## Dependencies

[11-fontawesome-pinned-package-spike.md](11-fontawesome-pinned-package-spike.md).

## Estimated Complexity

Small.

## Coding Agent Safe?

The implementation is agent-safe; the go/no-go call itself is a human decision informed by spec 11.
