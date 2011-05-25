require 'spec_helper'

describe PersonSearch::Name do
	it 'should exist' do
		defined?(PersonSearch::Name).should be_true
	end

	specify 'table name should be person_search_names' do
		PersonSearch::Name.table_name.should == 'person_search_names'
	end

	let(:model) { Factory.build :name }

	model_responds_to :text,
									  :name_relationship
end
