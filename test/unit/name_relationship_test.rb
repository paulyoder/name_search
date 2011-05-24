require 'test_helper'

class NameRelationshipTest < ActiveSupport::TestCase
	def relationship
		@@relationship ||= PersonSearch::NameRelationship.new
	end

	test 'class exists' do
		assert defined? PersonSearch::NameRelationship
	end

	test 'table is person_search_name_relationships' do
		assert_equal 'person_search_name_relationships',
									PersonSearch::NameRelationship.table_name
	end

	test 'has_many names' do
		assert relationship.respond_to? :names
	end
end
