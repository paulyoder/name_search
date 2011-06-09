module NameSearch
	module NameSearchOn
		def name_search_on(*attributes)
			write_inheritable_attribute(:name_search_attributes, attributes)
			class_inheritable_reader(:name_search_attributes)

			class_eval do
				include NameSearchablesConcerns

				after_save :sync_name_searchables
				has_many :name_searchables, :as => :searchable, :dependent => :destroy,
					:include => :name, :class_name => 'NameSearch::Searchable'
			end
		end
	end
end

ActiveRecord::Base.send :extend, NameSearch::NameSearchOn
