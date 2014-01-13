# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'will-style/will-style/version'

Gem::Specification.new do |s|
  s.name     = "will-style"
  s.version  = WillStyle::VERSION
  s.authors  = ["Caroline Horn"]
  s.email    = 'chorn@willinteractive.com'
  s.summary  = "WILL custom styling built on top of bootstrap-sass"
  s.homepage = "http://github.com/willinteractive/will-style"
  s.license  = 'MIT'

  s.add_development_dependency "bundler", "~> 1.5"
  s.add_development_dependency "rake"
  
  s.require_path = 'lib'

  s.files = Dir["app/assets/**/*", "vendor/assets/**/*", "Readme.md"]
end
