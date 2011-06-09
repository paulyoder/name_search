module NameSearch
	class SearchResult
		attr_accessor :model, :matched_names, :exact_name_matches, :nick_name_matches, :match_score

		def initialize(model, searched_names, searched_nick_names)

		end
	end
end
