module NameSearch
	class Search < Array
		def initialize(klass, names)
			matches = klass.joins(:name_searchables).
									where(:name_search_searchables => { 
													:name_id => name_search_names(names) }).
									all.
									uniq
			self.concat(matches)
		end

		def name_search_names(names)
			Name.where(:value => names.split).select('id').map(&:id)
		end
	end
end
