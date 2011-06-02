require 'spec_helper'

describe NameSearch::NickNameFamily do
	it 'should exist' do
		defined?(NameSearch::NickNameFamily).should be_true
	end

	specify 'table name should be name_search_nick_name_families' do
		NameSearch::NickNameFamily.table_name.should == 'name_search_nick_name_families'
	end

	let(:model) { NameSearch::NickNameFamily.new }

	model_responds_to :names
end
