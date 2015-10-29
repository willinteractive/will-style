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

  s.add_dependency "rails", "~> 4.1"

  # @NOTE: Need to lock Foundation at 5.5.2 until 5.5.4 comes out
  s.add_dependency "foundation-rails", "5.5.2.1"
  s.add_dependency "font-awesome-rails", "~> 4.4"
  s.add_dependency "modernizr-rails", "~> 2.7.1"

  s.add_dependency "sass-rails", "~> 5.0.4"

  s.add_dependency 'coffee-rails', "~> 4.0.1"
  s.add_dependency 'autoprefixer-rails', "~> 6.0.3"

  s.add_development_dependency "bundler", "~> 1.5"

  s.add_development_dependency "sass-rails-source-maps", "~> 0.1.0"
end
