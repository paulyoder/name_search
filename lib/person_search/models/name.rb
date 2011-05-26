module PersonSearch
	class Name < ActiveRecord::Base
		set_table_name :person_search_names

		belongs_to :nick_name_family, :class_name => 'PersonSearch::NickNameFamily'

		validates :value, :uniqueness => true

		def self.add_nick_name(first_name, second_name)
			family = NickNameFamily.create
			Name.create! :value => first_name, :nick_name_family => family
			Name.create! :value => second_name, :nick_name_family => family
		end
	end
end
