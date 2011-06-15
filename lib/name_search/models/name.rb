module NameSearch
  class Name < ActiveRecord::Base
    set_table_name :name_search_names
    before_create :downcase_value

    has_many :nick_name_family_joins
    has_many :nick_name_families, :through => :nick_name_family_joins
            
    def nick_names()
      nick_name_families.map(&:names).flatten
    end

    def nick_name_values()
      nick_names.map(&:value)
    end

    validates :value, :uniqueness => true

    cattr_accessor :excluded_values
    @@excluded_values = %w( and or )

    def self.find(*args)
      return Name.where(:value => args.first).first if args.first.kind_of?(String)
      super
    end

    def self.scrub_and_split_name(name)
      scrubbed = name.downcase.gsub(/[^a-z0-9 -]/, '')
      split = scrubbed.split(/[ -]/).uniq
      split - @@excluded_values
    end

    private
    
    def self.get_family_for_nick_names(names)
      family = Name.where(:value => names.map(&:downcase)).
                    where('nick_name_family_id IS NOT NULL').
                    first.
                    try(:nick_name_family)
      family ||= NickNameFamily.create
    end

    def downcase_value
      value.downcase!
    end
  end
end
