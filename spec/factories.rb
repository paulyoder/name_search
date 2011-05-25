Factory.define :name, :class => PersonSearch::Name do |t|  
  t.text 'Paul'  
end

Factory.define :name_relationship, :class => PersonSearch::NameRelationship do |t|
end

Factory.define :name_person_join, :class => PersonSearch::NamePersonJoin do |t|
	t.association :name
end
