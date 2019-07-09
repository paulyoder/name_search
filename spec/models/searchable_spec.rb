require 'spec_helper'

describe NameSearch::Searchable do
  it 'should exist' do
    expect(defined?(NameSearch::Searchable)).to eq 'constant'
  end

  specify 'table name should be name_search_searchables' do
    expect(NameSearch::Searchable.table_name).to eq 'name_search_searchables'
  end

  let(:model) { Factory.build :name_searchable }

  model_responds_to :name,
                    :searchable

  model_requires :name,
                 :searchable
end
