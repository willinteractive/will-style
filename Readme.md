# WILL Styles for Web Apps


### Installation

```ruby
# Required Gems
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'jquery-rails'

gem 'will-style', :git => "https://github.com/willinteractive/will-style"
```
To write a template styles sass file in your app, use this generator:

```ruby
rails g will:style:sass
```

This will write a custom-will-styles.scss file in your app/assets/stylesheets folder so you can include / remove whatever styles you want.

--

See the Gemfile for other gems that other components may require.

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


#### Updating docs

```
$ rake rdoc
```

RDoc Formatting Guide: http://ruby-doc.org/gems/docs/r/rdoc-4.1.1/RDoc/Markup.html

#### Bower configuration

To use this gem as a bower module, just use this dependency:

```
"will-style": "git@github.com:willinteractive/will-style.git#foundation"
```

Be sure that you've also installed compass to your package file. In your compass configuration, make sure your settings include:

``
add_import_path "bower_components/foundation/scss"
add_import_path "bower_components/will-style/lib/assets/stylesheets"
add_import_path "bower_components/font-awesome/scss"
```

You can also add this to your gruntfile in the compass config like so (this is for a yeoman installation):

```
raw: 'add_import_path "<%= yeoman.app %>/_bower_components/foundation/scss"\nadd_import_path "<%= yeoman.app %>/_bower_components/will-style/lib/assets/stylesheets"\nadd_import_path "<%= yeoman.app %>/_bower_components/will-style/lib/assets/stylesheets/will-style/core"\nadd_import_path "<%= yeoman.app %>/_bower_components/font-awesome/scss"\n'
```

@TODO: Figure out javascript configuration

