require 'spec_helper'

describe PersonSearch::Name do
	it 'should exist' do
		defined?(PersonSearch::Name).should be_true
	end

	specify 'table name should be person_search_names' do
		PersonSearch::Name.table_name.should == 'person_search_names'
	end

	let(:model) { Factory.build :name }

	model_should_respond_to :text,
													:name_relationship

	it 'can add a name_relationship' do
		name = PersonSearch::Name.new
		relationship = PersonSearch::NameRelationship.create
		name.name_relationship = relationship

		name.save.should be_true
	end
end
