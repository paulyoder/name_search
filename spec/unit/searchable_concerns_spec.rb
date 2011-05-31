require 'spec_helper'

describe NameSearch::SearchableConcerns do
	it 'adds full_name_search_on to ActiveRecord::Base class methods' do
		ActiveRecord::Base.should respond_to :name_search_on
	end

	describe 'name_search_on' do

		describe 'name_searchables' do
			it 'adds a polymorphic association to name_searchables' do
				Customer.new.should respond_to :name_searchables
			end
			
			it 'adds a dependent => destroy option to name_searchables' do
				name = Factory :name
				customer = Customer.create!
				searchable = customer.name_searchables.create! :name => name
				customer.destroy
				NameSearch::Searchable.where(:id => searchable.id).count.should == 0
			end
		end

		it 'adds a before_save filter on the attribute' do
			Customer._save_callbacks.
				select{|x| x.kind == :before && 
									 x.filter == :sync_name_values &&
									 x.options[:if].first == :name_changed?}.
				length.should == 1
		end

		it 'adds name_search_attributes class instance variable' do
			Customer.should respond_to :name_search_attributes
		end

		it 'sets name_search_attributes value to the attribute argument' do
			Customer.name_search_attributes.should == :name
		end
	end

	describe 'sync_name_values' do
		it 'saves splits the names and saves each one'
	end
end
