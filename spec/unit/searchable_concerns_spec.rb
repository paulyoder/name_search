require 'spec_helper'

describe PersonSearch::SearchableConcerns do
	it 'adds full_name_search_on to ActiveRecord::Base class methods' do
		ActiveRecord::Base.should respond_to :full_name_search_on
	end

	describe 'full_name_search_on' do
		it 'adds a before_save filter on the attribute' do
			Customer._save_callbacks.select{|x| x.kind == :before && x.filter == :check}.length.should == 1
		end
	end
end
