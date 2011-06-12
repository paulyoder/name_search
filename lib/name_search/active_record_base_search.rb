module NameSearch
  module ActiveRecordBaseSearch
    def name_search(name, options = {})
      NameSearch::Search.new(self, name, options)
    end
  end
end

ActiveRecord::Base.send :extend, NameSearch::ActiveRecordBaseSearch
