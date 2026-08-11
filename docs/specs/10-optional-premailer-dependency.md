# 10 — Declare premailer-rails as optional (P4)

## Current State

`Readme.md` says: "We use premailer-rails to style emails inline. Be sure to include it in your Gemfile if you're sending emails." It is not declared in `will_style.gemspec` — a consumer can easily miss this note and ship unstyled emails.

## Desired Outcome

`premailer-rails` is discoverable/manageable through normal dependency tooling as an optional dependency, rather than a README-only note.

## Recommended Approach

RubyGems has no native "optional dependency" concept equivalent to npm's `optionalDependencies`. Recommended pattern: leave it undeclared in the gemspec, but have the engine detect at load time whether `premailer-rails` is available (`defined?(PremailerRails)` or an equivalent `Gem::Specification.find_by_name` check) and only wire in email-related config if so — with a clear log/warning if the email partials are rendered without it present. This keeps it genuinely optional rather than forcing it on every consumer, which is what the team's "optional" answer implied.

## Risks and Tradeoffs

The load-time-detection approach requires a small amount of conditional logic in `engine.rb`; the simpler alternative (declare it as a hard runtime dependency) is easier to implement but forces the gem on every consumer even if they never render email partials — rejected per the team's explicit "optional" preference.

## Rollback Plan

Trivial `engine.rb`/README revert.

## Acceptance Criteria

- A consuming app without `premailer-rails` in its Gemfile still boots and uses non-email will-style features normally.
- A consuming app that does declare `premailer-rails` gets working inlined email styling as before.

## Dependencies

None.

## Estimated Complexity

Trivial.

## Coding Agent Safe?

Yes.

## Outcome (2026-08-11)

Implemented, and simpler than the spec anticipated: there was no existing engine-level config wired to `premailer-rails` at all (grep found zero references anywhere in `lib/`/`config/` — only the README note). So there was nothing to conditionally gate; the actual gap was pure discoverability. Added a `Rails.logger.warn` at the top of `app/views/will_style/components/_email.html.erb` (the email layout) that fires when `PremailerRails` isn't defined, since without it the `stylesheet_link_tag` in that layout produces a `<link>` most email clients ignore — i.e. the email would silently render unstyled. `Readme.md` updated to mention the warning. No gemspec change, per the original recommendation.

Covered by two new specs in `spec/views/will_style/components/_email_html_erb_spec.rb` (rendering the layout without `premailer-rails` present still succeeds; the warning fires with the expected message). Required adding `spec/internal/app/assets/{images,javascripts,stylesheets}/` to the dummy app — the manifest's `link_tree ../images` needs a real directory to resolve, which hadn't been exercised by the F4 specs since they never rendered a view that pulls in `stylesheet_link_tag`.
