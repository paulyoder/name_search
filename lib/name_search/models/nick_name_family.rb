module NameSearch
  class NickNameFamily < ActiveRecord::Base
    set_table_name :name_search_nick_name_families

    has_many :nick_name_family_joins
    has_many :names, :through => :nick_name_family_joins

    def self.create_family(*nick_names)
      family = NickNameFamily.create
      scrubbed_names = nick_names.map{|x| Name.scrub_and_split_name(x)}.flatten
      scrubbed_names.each do |name|
        family.names << Name.find_or_create_by_value(name)
      end
      family
    end
  end
end
