module PersonSearch
	module SearchableConcerns
		def self.included(base)
			base.extend ClassMethods
		end

		def sync_name_values
			true
		end

		module ClassMethods
			def full_name_search_on(attribute)
				write_inheritable_attribute(:person_search_on, attribute)
				class_inheritable_reader(:person_search_on)

				class_eval do
					has_many :name_searchables, :as => :searchable, :dependent => :destroy, :include => :name, :class_name => 'PersonSearch::NameSearchable'
					before_save :sync_name_values, :if => "#{attribute}_changed?".to_sym
				end
			end
		end
	end
end

ActiveRecord::Base.send :include, PersonSearch::SearchableConcerns
