module NameSearch
  module NameSearchablesConcerns
    def sync_name_searchables
      return unless name_search_attributes_changed?
      update_name_searchables
    end

    def update_name_searchables
      names = name_search_attributes_names
      create_new_name_searchables(names)
      destroy_orphaned_name_searchables(names)
    end
    
    def name_searchable_values(force_reload = false)
      name_searchables(force_reload).map{|x| x.name.value}
    end

    def name_search_attributes_names()
      names = []
      attributes = self.class.name_search_attributes
      attributes.each do |att|
        value = self.send(att)
        names.concat(NameSearch::Name.scrub_and_split_name(value))
      end
      names
    end

    def create_new_name_searchables(names)
      names_to_add = names - name_searchable_values
      names_to_add.each do |name|
        name_searchables.create name: NameSearch::Name.find_or_create_by(value: name)
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
  end
end
