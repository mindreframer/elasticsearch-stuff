require File.expand_path('../lib/daedal-sl/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'daedal-sl'
  s.version     = DaedalSL::VERSION
  s.summary     = "ElasticSearch Query Writing Block DSL"
  s.description = "Ruby block DSL for easier ElasticSearch query creation"
  s.authors     = ["Christopher Schuch"]
  s.email       = 'cas13091@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.license     = 'MIT'
  s.homepage    =
    'https://github.com/cschuch/daedal-sl'

  s.add_dependency('daedal', '~> 0.0.9')
end