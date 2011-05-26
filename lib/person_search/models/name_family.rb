module PersonSearch
	class NameFamily < ActiveRecord::Base
		set_table_name :person_search_name_families

		has_many :names
	end
end
