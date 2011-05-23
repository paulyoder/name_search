module PersonSearch
	class Name < ActiveRecord::Base
		set_table_name :person_search_names

		belongs_to :name_relationship
	end
end
