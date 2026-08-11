# WILL Styles for Web Apps

### Optional Libraries

We use premailer-rails to style emails inline. Be sure to include it in your Gemfile if you're sending emails. It's intentionally not a declared dependency of this gem, so apps that don't send email don't have to carry it — if you render the `will_style/components/email` layout without it installed, a warning is logged to `Rails.logger` since the email will otherwise render unstyled in most clients.
