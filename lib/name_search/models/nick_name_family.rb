module NameSearch
	class NickNameFamily < ActiveRecord::Base
		set_table_name :name_search_nick_name_families

		has_many :names
	end
end
