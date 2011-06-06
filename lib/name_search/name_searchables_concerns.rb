module NameSearch
	module NameSearchablesConcerns
		def sync_name_searchables
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
	end
end
