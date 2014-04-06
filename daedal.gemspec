require File.expand_path('../lib/daedal/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'daedal'
  s.version     = Daedal::VERSION
  s.summary     = "ElasticSearch Query DSL Builders"
  s.description = "Classes for easier ElasticSearch query creation"
  s.authors     = ["Christopher Schuch"]
  s.email       = 'cas13091@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.license     = 'MIT'
  s.homepage    =
    'https://github.com/cschuch/daedal'

  s.add_dependency('virtus', '>= 1.0.0')
end