module PersonSearch
	require 'person_search/railtie.rb' if defined?(Rails) && Rails::VERSION::MAJOR == 3
	require 'person_search/models/name.rb'
	require 'person_search/models/name_relationship.rb'
	require 'person_search/models/name_person_join.rb'
end
