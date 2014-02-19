$:.push File.expand_path("../lib", __FILE__)
require 'name_search/version'

Gem::Specification.new do |s|
  s.name        = 'name_search'
  s.summary     = "Perform intelligent searches on people’s names."
  s.description = "Name search uses common nick names and first name/last name ordering to perform its searches."
  s.authors     = ['Paul Yoder']
  s.email       = ['paulyoder@gmail.com']
  s.homepage    = 'https://github.com/paulyoder/name_search'

  s.add_dependency 'rails', '>= 4.0.0'

  s.files   = Dir["lib/**/*"] + ['MIT-LICENSE', 'Rakefile', 'Gemfile', 'README.rdoc']
  s.version = NameSearch::VERSION
end
