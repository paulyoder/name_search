require 'spec_helper'

describe NameSearch::ActiveRelationSearch do
  it 'should be included in ActiveRecord::Relation' do
    ActiveRecord::Relation.ancestors.second.should == NameSearch::ActiveRelationSearch
  end
end
