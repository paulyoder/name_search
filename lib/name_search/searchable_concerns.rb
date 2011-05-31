module NameSearch
	module SearchableConcerns
		def self.included(base)
			base.extend ClassMethods
		end

		def sync_name_values
			true
		end

		module ClassMethods
			def name_search_on(attribute)
				write_inheritable_attribute(:name_search_attributes, attribute)
				class_inheritable_reader(:name_search_attributes)

				class_eval do
					has_many :name_searchables, :as => :searchable, :dependent => :destroy,
						:include => :name, :class_name => 'NameSearch::Searchable'
					before_save :sync_name_values, :if => "#{attribute}_changed?".to_sym
				end
			end
		end
	end
end

ActiveRecord::Base.send :include, NameSearch::SearchableConcerns
