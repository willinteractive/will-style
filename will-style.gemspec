# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'will/style/version'

Gem::Specification.new do |s|
  s.name     = "will-style"
  s.version  = Will::Style::VERSION
  s.authors  = ["Caroline Horn"]
  s.email    = 'chorn@willinteractive.com'
  s.summary  = "WILL custom styling built on top of bootstrap-sass"
  s.description  = "WILL Style"
  s.homepage = "http://github.com/willinteractive/will-style"
  s.license  = 'MIT'

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "bootstrap-sass", "~> 3.0"

  s.add_development_dependency "bundler", "~> 1.5"

  s.require_path = 'lib/will/'

  s.files = Dir["app/assets/**/*", "vendor/assets/**/*", "lib/will/**/*", "Readme.md"]
end
