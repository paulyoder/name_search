module NameSearch
	module NameSearchOn
		def name_search_on(*attributes)
			write_inheritable_attribute(:name_search_attributes, attributes)
			class_inheritable_reader(:name_search_attributes)

			class_eval do
				include NameSearchablesConcerns

				after_save :sync_name_values
				has_many :name_searchables, :as => :searchable, :dependent => :destroy,
					:include => :name, :class_name => 'NameSearch::Searchable'
				
				def name_searchable_values(force_reload = false)
					name_searchables(force_reload).map{|x| x.name.value}
				end
			end
		end
	end
end

ActiveRecord::Base.send :extend, NameSearch::NameSearchOn
