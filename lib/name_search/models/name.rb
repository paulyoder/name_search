module NameSearch
	class Name < ActiveRecord::Base
		set_table_name :name_search_names
		before_create :downcase_value

		belongs_to :nick_name_family, :class_name => 'NameSearch::NickNameFamily'

		has_many :nick_names, :through => :nick_name_family, :source => :names
		def nick_name_values()
			nick_names.map(&:value)
		end

		validates :value, :uniqueness => true

		def self.relate_nick_names(*names)
			family = get_family_for_nick_names(names)
			names.each do |name|
				name_record = Name.find(name)
				if name_record.nil?
					name_record = Name.create! :value => name, :nick_name_family => family
				elsif name_record.nick_name_family != family
					name_record.nick_name_family = family
					name_record.save!
				end
			end
		end

		def self.find(*args)
			return Name.where(:value => args.first).first if args.first.kind_of?(String)
			super
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
