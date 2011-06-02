module NameSearch
	module SearchableConcerns
		def self.included(base)
			base.extend ClassMethods
		end

		def sync_name_values
			return unless name_search_attributes_changed?
			names = name_search_attributes_names
			create_new_name_searchables(names)
			destroy_orphaned_name_searchables(names)
		end

		def name_search_attributes_names()
			names = []
			attributes = self.class.name_search_attributes
			attributes.each do |att|
				att_value = self.send(att)
				att_names = att_value.split(/[ -]/)
				att_names.each{ |att_name| names << scrub_name(att_name) }
			end
			names
		end

		def create_new_name_searchables(names)
			names.uniq.each do |name|
				next if NameSearch::Name.excluded_values.include?(name)
				next if name_searchable_values.include?(name)
				name_searchables.create :name => NameSearch::Name.find_or_create_by_value(name)
			end
		end

		#Destroys name_searchable values that used to exist but don't exist any longer
		#Example: 'Jen York' changes to 'Jen Yoder', then 'york' would be destroyed
		def destroy_orphaned_name_searchables(names)
			orphaned_names = name_searchable_values - names
			orphaned_names.each do |orphan_name|
				searchable = name_searchables.select{|x| x.name.value == orphan_name}.first
				searchable.destroy if searchable.present?
			end
		end

		def name_search_attributes_changed?()
			(changed & self.class.name_search_attributes.map(&:to_s)).length > 0
		end

		def scrub_name(name)
			name.downcase.gsub(/[^A-Za-z0-9]/, '')
		end

		module ClassMethods
			def name_search_on(*attributes)
				write_inheritable_attribute(:name_search_attributes, attributes)
				class_inheritable_reader(:name_search_attributes)

				class_eval do
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
end

ActiveRecord::Base.send :include, NameSearch::SearchableConcerns
