require 'spec_helper'

describe NameSearch::Searchable do
	it 'should exist' do
		defined?(NameSearch::Searchable).should be_true
	end

	specify 'table name should be person_search_name_searchables' do
		NameSearch::Searchable.table_name.should == 'name_search_searchables'
	end

	let(:model) { Factory.build :name_searchable }

	model_responds_to :name,
										:searchable

	model_requires :name,
								 :searchable
end
