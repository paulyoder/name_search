require 'spec_helper'

describe PersonSearch::NameFamily do
	it 'should exist' do
		defined?(PersonSearch::NameFamily).should be_true
	end

	specify 'table name should be person_search_name_families' do
		PersonSearch::NameFamily.table_name.should == 'person_search_name_families'
	end

	let(:model) { PersonSearch::NameFamily.new }

	model_responds_to :names
end
