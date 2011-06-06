module PersonSearch
	require 'name_search/railtie.rb' if defined?(Rails) && Rails::VERSION::MAJOR == 3
	require 'name_search/models/name.rb'
	require 'name_search/models/nick_name_family.rb'
	require 'name_search/models/searchable.rb'
	require 'name_search/name_search_on.rb'
	require 'name_search/name_searchables_concerns.rb'
end