require 'spec_helper'

describe NameSearch::NameSearchOn do
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

		describe 'name_searchable_values' do
			it 'maps name_searchbles.name.value' do
				c = Customer.create! :name => 'Paul Yoder'
				c.name_searchable_values.should include('paul', 'yoder')
			end
		end

		context 'after_save callback' do
			it 'calls sync_name_searchables method' do
				Customer._save_callbacks.
					select{|x| x.kind == :after && 
										 x.filter == :sync_name_searchables}.
					length.should == 1
			end

			it 'gets called if the single attribute changes' do
				c = Customer.create! :name => 'Paul'
				c.name_searchables.length.should == 1
			end
			
			it 'gets called if the last of multiple attributes changes' do
				u = User.create! :first_name => 'Paul', :last_name => 'Yoder'
				u.last_name = 'Smith'
				u.save!
				u.name_searchables(true).map{|x| x.name.value}.should include('smith')
			end
		end

		it 'adds name_search_attributes class instance variable' do
			Customer.should respond_to :name_search_attributes
		end

		it 'sets name_search_attributes value to the attribute argument' do
			Customer.name_search_attributes.should == [:name]
			User.name_search_attributes.should == [:first_name, :last_name]
		end
	end
end
