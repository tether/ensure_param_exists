Gem::Specification.new do |s|
  s.name        = 'ensure_param_exists'
  s.version     = '0.0.2'
  s.date        = '2013-10-01'
  s.summary     = "Simple mixin to generate ensure_param_exist methods"
  s.description = "A quick mixin that lets you quickly define methods to ensure a parameter exists on a request"
  s.authors     = ["Gavin Miller"]
  s.email       = 'gavin@petrofeed.com'
  s.files       = ["lib/ensure_param_exists.rb"]
  s.homepage    = ''
  s.license     = 'MIT'
  s.add_runtime_dependency 'rails', ['~> 4.0.0']
end
