module NameSearch
  module NameSearchOn
    def name_search_on(*attributes)
      def name_search(name, options = {})
        NameSearch::Search.new(self, name, options)
      end

      class_eval do
        include NameSearchablesConcerns
        class_attribute :name_search_attributes
        self.name_search_attributes = attributes

        after_save :sync_name_searchables
        has_many :name_searchables, -> { includes :name }, as: :searchable,
          dependent: :destroy, class_name: 'NameSearch::Searchable'
      end
    end
  end
end

ActiveRecord::Base.send :extend, NameSearch::NameSearchOn
