require 'spec_helper'

describe PersonSearch::NameRelationship do
	it 'should exist' do
		defined?(PersonSearch::NameRelationship).should be_true
	end

	specify 'table name should be person_search_name_relationships' do
		PersonSearch::NameRelationship.table_name.should == 'person_search_name_relationships'
	end

	let(:model) { PersonSearch::NameRelationship.new }

	model_responds_to :names
end
