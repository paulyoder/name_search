require 'spec_helper'

describe NameSearch::NickNameFamilyJoin do
  it 'should exist' do
    defined?(NameSearch::NickNameFamilyJoin).should be_true
  end
  
  specify 'table name should be name_search_nick_name_family_joins' do
    NameSearch::NickNameFamilyJoin.table_name.should == 'name_search_nick_name_family_joins'
  end

  let(:model) { NameSearch::NickNameFamilyJoin.new }

  model_responds_to :name,
                    :nick_name_family
end
