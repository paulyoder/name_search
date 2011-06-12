module NameSearch
  class SearchResult
    attr_reader :model, :matched_names, :exact_name_matches, :nick_name_matches, :match_score

    def initialize(model, searched_names, searched_nick_names)
      @model              = model
      @exact_name_matches = model.name_searchable_values & searched_names
      @nick_name_matches  = model.name_searchable_values & searched_nick_names
      @matched_names      = @exact_name_matches + @nick_name_matches
      @match_score        = (@exact_name_matches.length * 4) +
                            (@nick_name_matches.length * 3)
    end
  end
end
