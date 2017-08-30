# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'will-style/version'

Gem::Specification.new do |s|
  s.name     = "will-style"
  s.version  = Will::Style::VERSION
  s.authors  = ["The WILL Ninja Team"]
  s.email    = ["ninja.team@willinteractive.com"]
  s.summary  = "WILL custom styling built on top of foundation"
  s.description  = "WILL Style"
  s.homepage = "http://github.com/willinteractive/will-style"
  s.license  = 'MIT'

  s.files = `git ls-files`.split("\n")

  s.add_dependency "rails", "~> 5.0"

  s.add_dependency "jquery-rails", "~> 4.3"

  # @NOTE: Need to lock Foundation at 5.5.2 until 5.5.4 comes out
  # @NOTE2: Foundation-Rails 5.5.4 is never coming out, we'll need to update to 6
  s.add_dependency "foundation-rails", "5.5.2.1"

  s.add_dependency "font-awesome-rails", "~> 4.4"
  s.add_dependency "modernizr-rails", "~> 2.7.1"

  s.add_dependency "sassc-rails", "~> 1.3.0"

  s.add_dependency 'coffee-rails', "~> 4.2.2"
  s.add_dependency 'autoprefixer-rails', "~> 7.1.3"

  # @NOTE: We can use this, once turbolinks-rails is out of beta
  # s.add_dependency 'turbolinks-rails', "~> 5.0.3"

  s.add_development_dependency "bundler", "~> 1.5"

end
