# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'icelastic/version'

Gem::Specification.new do |spec|
  spec.name          = "icelastic"
  spec.version       = Icelastic::VERSION
  spec.authors       = ["RDux"]
  spec.email         = ["data@npolar.no"]
  spec.description   = "Library that provides advanced elasticsearch query functionality in the url."
  spec.summary       = "Exposes elasticsearch on the url using a Rack middleware for easy injection in server stack."
  spec.homepage      = "https://github.com/npolar/icelastic"
  spec.license       = "GPLv3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "simplecov"

  spec.add_dependency "rack"
  spec.add_dependency "yajl-ruby"
  spec.add_dependency "elasticsearch"
end
