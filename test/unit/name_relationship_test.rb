require 'test_helper'

class NameRelationshipTest < ActiveSupport::TestCase
	test 'class exists' do
		assert defined? PersonSearch::NameRelationship
	end

	test 'table is person_search_name_relationships' do
		assert_equal 'person_search_name_relationships',
									PersonSearch::NameRelationship.table_name
	end
end
