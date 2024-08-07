# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'will-style/version'

Gem::Specification.new do |s|
  s.name     = "will-style"
  s.version  = Will::Style::VERSION
  s.authors  = ["The WILL Developers"]
  s.email    = ["developers@willinteractive.com"]
  s.summary  = "WILL custom styling built on top of foundation"
  s.description  = "WILL Style"
  s.homepage = "https://github.com/willinteractive/will-style"
  s.license  = 'MIT'

  s.files = `git ls-files`.split("\n")

  s.add_dependency "rails", ">= 6.0"

  s.add_dependency "jquery-rails", "~> 4.3"

  s.add_dependency "bootstrap", "~> 5.3.1"

  s.add_dependency "dartsass-sprockets", "~> 3.0.0"

  s.add_dependency 'coffee-rails', "~> 4.2"
  s.add_dependency 'autoprefixer-rails', ">= 9.1"

  s.add_dependency 'turbo-rails', "~> 2.0.5"

  s.add_development_dependency "bundler", "~> 2.2.18"

end
