# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arithmetic/version'

Gem::Specification.new do |gem|
  gem.name          = "arithmetic"
  gem.version       = Arithmetic::VERSION
  gem.authors       = ["Sean Kirby"]
  gem.email         = ["seank@nulogy.com"]
  gem.description   = %q{Simple arithmetic calculator for Ruby}
  gem.summary       = %q{Simple arithmetic calculator for Ruby}
  gem.homepage      = "https://github.com/nulogy/arithmetic"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency('rspec')
end
