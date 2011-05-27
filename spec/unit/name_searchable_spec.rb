require 'spec_helper'

describe PersonSearch::NameSearchable do
	it 'should exist' do
		defined?(PersonSearch::NameSearchable).should be_true
	end

	specify 'table name should be person_search_name_searchables' do
		PersonSearch::NameSearchable.table_name.should == 'person_search_name_searchables'
	end

	let(:model) { Factory.build :name_searchable }

	model_responds_to :name,
										:searchable

	model_requires :name,
								 :searchable
end
