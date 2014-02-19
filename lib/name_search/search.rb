module NameSearch
  class Search < Array
    def initialize(klass_or_query, name, options = {})
      name_values = Name.scrub_and_split_name(name)
      names = get_names(name_values)
      nick_names = (options[:match_mode] == :exact) ?
        [] :
        get_nick_names(names)

      results = matched_models(klass_or_query, names + nick_names).
                  map{|x| SearchResult.new(x, name_values, nick_names.map(&:value)) }.
                  sort{|a,b| b.match_score <=> a.match_score }

      if options.has_key?(:matches_at_least)
        results = results.delete_if{|x| x.matched_names.length < options[:matches_at_least] } 
      end
      
      self.concat(results)
    end

    private

    def matched_models(klass_or_query, names_to_search)
      klass_or_query.includes(:name_searchables).
        where(:name_search_searchables => { 
          :name_id => names_to_search.map(&:id) }).
        to_a.
        uniq
    end

    def get_names(name_values)
      Name.where(:value => name_values)
    end

    def get_nick_names(names)
      all_names = Name.joins(:nick_name_families).
           where("name_search_nick_name_families.id IN (#{
             NickNameFamily.joins(:names).
                            where(:name_search_names => { :value => names.map(&:value) }).
                            select('name_search_nick_name_families.id').
                            to_sql
           })").
           where('name_search_names.id NOT IN (?)', names.map(&:id))
    end
  end
end
