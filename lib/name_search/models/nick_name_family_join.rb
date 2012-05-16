module NameSearch
  class NickNameFamilyJoin < ActiveRecord::Base
    self.table_name = :name_search_nick_name_family_joins

    belongs_to :name
    belongs_to :nick_name_family
  end
end
