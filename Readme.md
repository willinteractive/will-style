# WILL Styles for Web Apps


### Installation

```ruby
# Required Gems
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'jquery-rails'

gem 'will-style', :git => "https://github.com/willinteractive/will-style"

```

You will also need to include font-awesome-pro, as it's required for our apps. Use the following instructions to install it: https://fontawesome.com/docs/web/use-with/ruby-on-rails

### Optional Libraries

We use premailer-rails to style emails inline. Be sure to include it in your Gemfile if you're sending emails

### To Work On WILL Style Locally

Clone will-style to your machine.

Use the local version of the gem like this:

```ruby
gem 'will-style', :path => "/path/to/will-style"
```

If you add any files to this gem as you're working on it locally, you need to commit the files before they'll be accessible. You don't have to push that commit, just remember to commit the files as soon as you create them so you can work with them.

Finally, when switching between the local and the remote gem, be sure to delete:

* tmp/cache

and restart the app by saving:

* tmp/restart.txt
