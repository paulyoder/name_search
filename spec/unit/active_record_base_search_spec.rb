require 'spec_helper'

describe NameSearch::ActiveRecordBaseSearch do
  it 'should be included in ActiveRecord::Base' do
    ActiveRecord::Base.should respond_to :name_search
  end
end
