require 'spec_helper'

describe PersonSearch::NamePersonJoin do
	it 'should exist' do
		defined?(PersonSearch::NamePersonJoin).should be_true
	end

	specify 'table name should be person_search_name_person_joins' do
		PersonSearch::NamePersonJoin.table_name.should == 'person_search_name_person_joins'
	end

	let(:model) { Factory.build :name_person_join }

	model_responds_to :name,
										:person_id,
										:person_klass

	model_requires :name,
								 :person_id,
								 :person_klass
end
