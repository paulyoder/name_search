module NameSearch
  class Searchable < ActiveRecord::Base
    set_table_name :name_search_searchables

    belongs_to :name
    belongs_to :searchable, :polymorphic => true

    validates :name,        :presence => true
    validates :searchable,  :presence => true
  end
end
