module PersonSearch
	class NameSearchable < ActiveRecord::Base
		set_table_name :person_search_name_searchables

		belongs_to :name
		belongs_to :searchable, :polymorphic => true

		validates :name,				:presence => true
		validates :searchable,	:presence => true
	end
end
