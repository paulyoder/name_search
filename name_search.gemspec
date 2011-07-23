# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name        = "name_search"
  s.summary     = "Search for people's names while taking into consideration nick names and word ordering."
  s.description = "Search for people's names while taking into consideration nick names and word ordering."
  s.authors     = ["Paul Yoder"]
  s.email       = ["paulyoder@gmail.com"]
  s.homepage    = "https://github.com/paulyoder/name_search"

  s.add_depency "rails", "~> 3.0"

  s.files   = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.1"
end
