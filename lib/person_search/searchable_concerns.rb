module PersonSearch
	module SearchableConcerns
		def self.included(base)
			base.extend ClassMethods
		end

		def check
			true
		end

		module ClassMethods
			def full_name_search_on(attribute)
				class_eval do
					before_save :check
				end
			end

		end
	end
end

ActiveRecord::Base.send :include, PersonSearch::SearchableConcerns
