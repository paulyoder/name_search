module PersonSearch
	class NamePersonJoin < ActiveRecord::Base
		set_table_name :person_search_name_person_joins

		belongs_to :name

		validates :name,					:presence => true
		validates :person_id,			:presence => true
		validates :person_klass,	:presence => true
	end
end
