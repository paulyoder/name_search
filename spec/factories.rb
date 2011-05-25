Factory.define :name, :class => PersonSearch::Name do |t|  
  t.text { Factory.next(:unique_name) }
end

Factory.define :name_relationship, :class => PersonSearch::NameRelationship do |t|
end

Factory.define :name_person_join, :class => PersonSearch::NamePersonJoin do |t|
	t.association :name
end

Factory.sequence :unique_name do |n|
	"Paul #{n}"
end
