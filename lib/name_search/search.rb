module NameSearch
	class Search < Array
		def initialize(klass, name)
			names = Name.scrub_and_split_name(name)
			matches = klass.joins(:name_searchables).
									where(:name_search_searchables => { 
													:name_id => name_search_name_ids(names) }).
									all.
									uniq
			matches.sort!{|a,b| (b.name_searchable_values & names).length <=> (a.name_searchable_values & names).length }
			self.concat(matches)
		end

		def name_search_name_ids(names)
			Name.where(:value => names_and_nick_names(names)).select('id').map(&:id)
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
