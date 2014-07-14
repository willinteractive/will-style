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

  s.add_dependency "rails", "~> 4.0"

  # @NOTE: 2.12.0 conflicts with something else in here (likely the specific SASS gem),
  # so we need to keep it at the previous version
  s.add_dependency "sprockets", "~> 2.11.0"

  # @NOTE: This is the only version of sass that works with compass 0.12.2
  s.add_dependency "sass", "3.3.0.alpha.149"
  
  s.add_dependency "sass-rails", "~> 4.0"
  s.add_dependency "compass-rails", "~> 1.1"
  s.add_dependency "foundation-rails", "5.2.2"
  s.add_dependency "font-awesome-rails", "~> 4.0"
  s.add_dependency "modernizr-rails", "~> 2.7"

  s.add_development_dependency "bundler", "~> 1.5"

  s.files = `git ls-files`.split("\n")
end
