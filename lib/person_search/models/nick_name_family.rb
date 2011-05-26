module PersonSearch
	class NickNameFamily < ActiveRecord::Base
		set_table_name :person_search_nick_name_families

		has_many :names
	end
end
