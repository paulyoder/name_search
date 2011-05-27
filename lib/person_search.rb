module PersonSearch
	require 'person_search/railtie.rb' if defined?(Rails) && Rails::VERSION::MAJOR == 3
	require 'person_search/models/name.rb'
	require 'person_search/models/nick_name_family.rb'
	require 'person_search/models/name_searchable.rb'
	require 'person_search/searchable_concerns.rb'
end
