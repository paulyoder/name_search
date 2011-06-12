Factory.define :name, :class => NameSearch::Name do |t|  
  t.value { Factory.next(:unique_name) }
end

Factory.define :nick_name_family, :class => NameSearch::NickNameFamily do |t|
end

Factory.define :name_searchable, :class => NameSearch::Searchable do |t|
  t.association :name
end

Factory.sequence :unique_name do |n|
  "Paul #{n}"
end
