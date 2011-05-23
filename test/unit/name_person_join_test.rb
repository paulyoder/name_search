require 'test_helper'

class NamePersonJoinTest < ActiveSupport::TestCase
	test 'class exists' do
		assert defined? PersonSearch::NamePersonJoin
	end

	test 'table is person_search_name_person_joins' do
		assert_equal 'person_search_name_person_joins',
									PersonSearch::NamePersonJoin.table_name
	end
end
