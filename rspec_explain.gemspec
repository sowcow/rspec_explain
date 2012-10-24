# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_explain/version'

Gem::Specification.new do |gem|
  gem.name          = "rspec_explain"
  gem.version       = RspecExplain::VERSION
  gem.authors       = ["Alexander K"]
  gem.email         = ["xpyro@ya.ru"]
  
  gem.description   = <<-DESC
    I'd like to write simple methods with simple specs
    so this gem gonna be easy to use
    with syntactic sugar to simplify the addition of examples
    but not so much configurable to shape a way you write methods
  DESC

  gem.summary       = %q[helpers to describe methods by concise input/output tables]
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency "rspec", "~> 2.0"
end
