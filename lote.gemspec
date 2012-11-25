# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lote/version'

Gem::Specification.new do |gem|
  gem.name          = "lote"
  gem.version       = Lote::VERSION
  gem.authors       = ["Sho Kusano"]
  gem.email         = ["rosylilly@aduca.org"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rack', '~> 1.4.1'
  gem.add_dependency 'hashr', '~> 0.0.22'
  gem.add_dependency 'tilt', '~> 1.3.3'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'named_let'
  gem.add_development_dependency 'tapp'
  gem.add_development_dependency 'slim'
  gem.add_development_dependency 'pry'
end
