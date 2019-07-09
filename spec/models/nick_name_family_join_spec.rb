require 'spec_helper'

describe NameSearch::NickNameFamilyJoin do
  it 'should exist' do
    expect(defined?(NameSearch::NickNameFamilyJoin)).to eq 'constant'
  end
  
  specify 'table name should be name_search_nick_name_family_joins' do
    expect(NameSearch::NickNameFamilyJoin.table_name).to eq 'name_search_nick_name_family_joins'
  end

  let(:model) { NameSearch::NickNameFamilyJoin.new }

  model_responds_to :name,
                    :nick_name_family
end
