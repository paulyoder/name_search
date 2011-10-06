$:.push File.expand_path("../lib", __FILE__)
require 'name_search/version'

Gem::Specification.new do |s|
  s.name        = 'name_search'
  s.summary     = "Perform natural searches on people’s names."
  s.description = "A natural search for a person by name will not only take into consideration word ordering ('Andrew Smith' == 'Smith, Andrew') but it will also look for nick names ('Andy' == 'Andrew')"
  s.authors     = ['Paul Yoder']
  s.email       = ['paulyoder@gmail.com']
  s.homepage    = 'https://github.com/paulyoder/name_search'

  s.add_dependency 'rails', '>= 3.0.0'

  s.files   = Dir["lib/**/*"] + ['MIT-LICENSE', 'Rakefile', 'Gemfile', 'README.rdoc']
  s.version = NameSearch::VERSION
end
