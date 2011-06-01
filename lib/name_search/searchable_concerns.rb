module NameSearch
	module SearchableConcerns
		def self.included(base)
			base.extend ClassMethods
		end

		def sync_name_values
			attributes = self.class.name_search_attributes
			attributes.each do |att|
				att_value = self.send("#{att}")
				names = att_value.split(/[ -]/)
				names.each do |name|
					name.gsub!(/[^A-Za-z0-9]/, '')
					name.downcase!
					next if %w( and & or ).include?(name)
					name_searchables.create :name => NameSearch::Name.find_or_create_by_value(name)
				end
			end
		end

		module ClassMethods
			def name_search_on(*attributes)
				write_inheritable_attribute(:name_search_attributes, attributes)
				class_inheritable_reader(:name_search_attributes)

				class_eval do
					has_many :name_searchables, :as => :searchable, :dependent => :destroy,
						:include => :name, :class_name => 'NameSearch::Searchable'
				end
				attributes.each do |attribute|
					class_eval do
						after_save :sync_name_values, :if => "#{attribute}_changed?".to_sym
					end
				end
			end
		end
	end
end

ActiveRecord::Base.send :include, NameSearch::SearchableConcerns
