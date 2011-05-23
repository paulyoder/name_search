require 'test_helper'

class NameTest < ActiveSupport::TestCase
	test 'class exists' do
		assert defined? PersonSearch::Name
	end

  test 'table is person_search_names' do
    assert_equal 'person_search_names',
                  PersonSearch::Name.table_name
  end

	test 'responds_to text' do
		assert PersonSearch::Name.new.respond_to? :text
	end

	test 'belongs_to name_relationship' do
		assert PersonSearch::Name.new.respond_to? :name_relationship
	end

	test 'can add name_relationship' do
		name = PersonSearch::Name.new
		relationship = PersonSearch::NameRelationship.create
		name.name_relationship = relationship
		assert name.save
	end
end
