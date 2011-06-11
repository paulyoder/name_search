module NameSearch
	class Search < Array
		def initialize(klass, name, options = {})
			name_values = Name.scrub_and_split_name(name)
      nick_values = (options[:match_mode] == :exact) ? [] : nick_name_values(name_values)

      results = matched_models(klass, name_values + nick_values).
                  map{|x| SearchResult.new(x, name_values, nick_values) }.
                  sort{|a,b| b.match_score <=> a.match_score }

      if options.has_key?(:matches_at_least)
        results = results.delete_if{|x| x.matched_names.length < options[:matches_at_least] } 
      end
      
			self.concat(results)
		end

    def matched_models(klass, name_values_to_search)
			klass.joins(:name_searchables).
			  where(:name_search_searchables => { 
				  :name_id => name_search_name_ids(name_values_to_search) }).
				all.
				uniq
    end

		def name_search_name_ids(name_values)
			Name.where(:value => name_values).select('id').map(&:id)
		end

    def nick_name_values(name_values)
      results = []
      name_values.each do |name|
        results.concat(Name.find(name).nick_name_values)
      end
      results - name_values
    end
	end
end
