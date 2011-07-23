$:.push File.expand_path("../lib", __FILE__)
require 'name_search/version'

Gem::Specification.new do |s|
  s.name        = 'name_search'
  s.summary     = "Search for people's names while taking into consideration nick names and word ordering."
  s.description = "Search for people's names while taking into consideration nick names and word ordering."
  s.authors     = ['Paul Yoder']
  s.email       = ['paulyoder@gmail.com']
  s.homepage    = 'https://github.com/paulyoder/name_search'

  s.add_dependency 'rails', '>= 3.0.0'

  s.files   = Dir["lib/**/*"] + ['MIT-LICENSE', 'Rakefile', 'Gemfile', 'README.rdoc']
  s.version = NameSearch::VERSION
end
