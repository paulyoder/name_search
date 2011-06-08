module NameSearch
	class Search < Array
		def initialize(klass, names)
			matches = klass.joins(:name_searchables).
									where(:name_search_searchables => { 
													:name_id => name_search_name_ids(names) }).
									all.
									uniq
			self.concat(matches)
		end

		def name_search_name_ids(names)
			scrubbed_names = Name.scrub_and_split_name(names)
			Name.where(:value => names_and_nick_names(scrubbed_names)).select('id').map(&:id)
		end

		def names_and_nick_names(names)
			results = []
			names.each do |name|
				results << name
				results.concat(Name.find(name).try(:nick_name_values))
			end
			results
		end
	end
end
