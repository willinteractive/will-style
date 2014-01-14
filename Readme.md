# WILL Styles for Web Apps
--------------------------


### Installation

```ruby
# Required Gems
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'jquery-rails'

gem 'will-style', :git => "https://github.com/willinteractive/will-style"
```

See the Gemfile for other gems that other components may require.

### To work on WILL Style Locally

Clone will-style to your machine.

Use the local version of the gem like this:

```ruby
gem 'will-style', :path => "/path/to/will-style"
```

<i>Note, when switching between the local and the remote gem, be sure to delete:</i> 

* tmp/cache

<i>and restart the app by saving:</i>

* tmp/restart.txt
