require 'spec_helper'

describe NameSearch::ActiveRelationSearch do
  it 'should be included in ActiveRecord::Relation' do
    expect(ActiveRecord::Relation.ancestors.second).to eq NameSearch::ActiveRelationSearch
  end
end
