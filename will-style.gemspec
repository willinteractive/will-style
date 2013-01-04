# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'will-style/version'

Gem::Specification.new do |gem|
  gem.name          = "will-style"
  gem.version       = Will::Style::VERSION
  gem.authors       = ["The WILL Ninja Team"]
  gem.email         = ["support@willinteractive.com.com"]
  gem.description   = %q{The will-style gem contains shared WILL branding for use across apps.}
  gem.summary       = %q{The will-style gem contains shared WILL branding for use across apps.}
  gem.homepage      = "https://github.com/willinteractive/will-style-guide"

  gem.add_dependency 'bootstrap-sass', '~> 2.2.2'

  gem.files = FileList['lib/*']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
