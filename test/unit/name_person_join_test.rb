require 'test_helper'

class NamePersonJoinTest < ActiveSupport::TestCase
	def join
		@@join ||= Factory.build :name_person_join
	end

	test 'class exists' do
		assert defined? PersonSearch::NamePersonJoin
	end

	test 'table is person_search_name_person_joins' do
		assert_equal 'person_search_name_person_joins',
									PersonSearch::NamePersonJoin.table_name
	end

	test 'belongs_to name' do
		assert join.respond_to? :name
	end

	test 'has person_id attribute' do
		assert join.respond_to? :person_id
	end

	test 'has person_klass attribute' do
		assert join.respond_to? :person_klass
	end

	test 'requires name' do
		requires join, :name
	end

	test 'requires person_id' do
		requires join, :person_id
	end

	test 'requires person_klass' do
		requires join, :person_klass
	end

	def requires(object, attribute)
		orig_val = object.send(attribute.to_s)
		object.send("#{attribute.to_s}=", nil)
		assert_equal false, object.valid?
		object.send("#{attribute.to_s}=", orig_val)
	end
end
