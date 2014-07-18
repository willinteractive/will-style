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

  s.add_dependency "rails", "~> 4.1"

  s.add_dependency "compass-rails", "~> 2.0"
  s.add_dependency "foundation-rails", "~> 5.3.1"
  s.add_dependency "font-awesome-rails", "~> 4.0"
  s.add_dependency "modernizr-rails", "~> 2.7"

  s.add_development_dependency "bundler", "~> 1.5"

  s.files = `git ls-files`.split("\n")

  # @FIXME: Untangle gem dependency knot for sass source maps

  # We need a 3.3 version of sass to enable source maps. 
  # This is the only one that's compatible with the only version
  # of sass-rails that allows for 3.3.
  s.add_dependency "sass", "3.3.0.alpha.149"

  # sass-rails locked the sass gem to 3.2 in 4.0.2 
  # and it's still locked :(
  s.add_dependency "sass-rails", "4.0.1"

  # Sprockets 2.12 is incompatible with sass-rails 4.0.1
  s.add_dependency "sprockets", "2.11.0"

  # The current version of this gem says it's compatible with compass-rails 2.0
  # which it might be, but it's not compatible wiht the version of sass-rails we're using.
  s.add_development_dependency "compass-rails-source-maps", "0.0.3"
end
