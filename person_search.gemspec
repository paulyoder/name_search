# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name 				= "person_search"
  s.summary 		= "Search for people based upon their full names while taking into consideration nick names and word ordering."
  s.description = "Search for people based upon their full names while taking into consideration nick names and word ordering."
	s.authors 		= ["Paul Yoder"]
	s.email 			= ["paulyoder@gmail.com"]
	s.homepage 		= "https://github.com/paulyoder/person_search"

	s.add_depency "rails", "~> 3.0"

  s.files 	= Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.1"
end
