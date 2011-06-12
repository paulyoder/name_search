module NameSearch
  module ActiveRelationSearch
    def name_search(name, options = {})
      NameSearch::Search.new(self, name, options)
    end
  end
end

ActiveRecord::Relation.send :include, NameSearch::ActiveRelationSearch
