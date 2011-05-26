module PersonSearch
	class Name < ActiveRecord::Base
		set_table_name :person_search_names

		belongs_to :family, :class_name => 'PersonSearch::NameFamily'

		validates :value, :uniqueness => true

		def self.add_nick_name(first_name, second_name)
			family = NameFamily.create
			Name.create! :value => first_name, :family => family
			Name.create! :value => second_name, :family => family
		end
	end
end
