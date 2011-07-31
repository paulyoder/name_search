module NameSearch
  class NickNameFamily < ActiveRecord::Base
    set_table_name :name_search_nick_name_families

    has_many :nick_name_family_joins
    has_many :names, :through => :nick_name_family_joins

    def self.create_family(*nick_names)
      family = NickNameFamily.create
      scrubbed_names = nick_names.flatten.map{|x| Name.scrub_and_split_name(x)}.flatten
      scrubbed_names.each do |name|
        family.names << Name.find_or_create_by_value(name)
      end
      family
    end

    def self.update_families_from_file(file_name)
      file = File.open(file_name)
      file.each_line do |line|
        process_file_line(line)
      end
    end

    private

    def self.process_file_line(line)
      scrubbed_name_values = line.split.map{|x| Name.scrub_and_split_name(x)}.flatten
      names = Name.where(:value => scrubbed_name_values).all
      first_name = names.find{|x| x.value == scrubbed_name_values.first}

      if should_create_new_family?(first_name, names)
        family = NickNameFamily.create
        scrubbed_name_values.each do |name|
          family.names << Name.find_or_create_by_value(name)
        end
      else
        scrubbed_name_values.from(1).each do |name|
          first_name.nick_name_families.first.names << Name.find_or_create_by_value(name)
        end
      end
    end

    def self.should_create_new_family?(first_name, names)
      first_name.nil? ||
      first_name.nick_name_families.length == 0 ||
      other_families(first_name, names).length > 0
    end

    def self.other_families(first_name, names)
      names.map(&:nick_name_family_ids).flatten.uniq - first_name.nick_name_family_ids
    end
  end
end
