require 'spec_helper'

describe PersonSearch::NickNameFamily do
	it 'should exist' do
		defined?(PersonSearch::NickNameFamily).should be_true
	end

	specify 'table name should be person_search_nick_name_families' do
		PersonSearch::NickNameFamily.table_name.should == 'person_search_nick_name_families'
	end

	let(:model) { PersonSearch::NickNameFamily.new }

	model_responds_to :names
end
