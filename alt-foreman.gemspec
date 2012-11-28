# -*- encoding: utf-8 -*-
require File.expand_path('../lib/alt-foreman/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Geoff Youngs\n"]
  gem.email         = ["git@intersect-uk.co.uk"]
  gem.description   = %q{Lightweight procfile runner}
  gem.summary       = %q{rubbish dev version of foreman}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "alt-foreman"
  gem.require_paths = ["lib"]
  gem.version       = Alt::Foreman::VERSION
  gem.add_dependency "term-ansicolor"
end
