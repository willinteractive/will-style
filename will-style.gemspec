# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'will/style/version'

Gem::Specification.new do |s|
  s.name     = "will-style"
  s.version  = Will::Style::VERSION
  s.authors  = ["The WILL Ninja Team"]
  s.email    = ["ninja.team@willinteractive.com"]
  s.summary  = "WILL custom styling built on top of bootstrap-sass"
  s.description  = "WILL Style"
  s.homepage = "http://github.com/willinteractive/will-style"
  s.license  = 'MIT'

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "bootstrap-sass", "~> 3.0"

  s.add_development_dependency "bundler", "~> 1.5"

  s.files = `git ls-files`.split("\n")
end
