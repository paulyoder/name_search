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

		describe 'name_searchable_values' do
			it 'maps name_searchbles.name.value' do
				c = Customer.create! :name => 'Paul Yoder'
				c.name_searchable_values.should include('paul', 'yoder')
			end
		end

		context 'after_save callback' do
			it 'calls sync_name_values method' do
				Customer._save_callbacks.
					select{|x| x.kind == :after && 
										 x.filter == :sync_name_values}.
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

	describe 'sync_name_values' do
		def new_customer(name)
			@customer = Customer.create! :name => name
		end

		def customer_name_values(force_reload = false)
			@customer.name_searchables(force_reload).map{|x| x.name.value }
		end

		specify 'first name' do
			new_customer('Paul')
			customer_name_values.should include('paul')
		end

		specify 'first and last name' do
			new_customer('Paul Yoder')
			customer_name_values.should include('paul', 'yoder')
		end

		specify 'first, spouse and last name' do
			new_customer('Paul and Jen Yoder')
			customer_name_values.should include('paul', 'jen', 'yoder')
		end

		specify 'last, first' do 
			new_customer('Yoder, Paul')
			customer_name_values.should include('paul', 'yoder')
		end

		specify 'hyphenated last name is split in 2' do
			new_customer('Sue Smith-Harrison')
			customer_name_values.should include('sue', 'smith', 'harrison')
		end

		context 'should not include' do
			specify '","' do
				new_customer('Yoder, Paul')
				customer_name_values.should_not include('yoder,')
			end

			specify '";"' do
				new_customer('Paul Yoder;,')
				customer_name_values.should_not include('yoder;,')
				customer_name_values.should include('yoder')
			end

			specify '"and"' do
				new_customer('Paul And Jen Yoder')
				customer_name_values.should_not include('and')
			end

			specify '"&"' do
				new_customer('Paul & Jen Yoder')
				customer_name_values.should_not include('&')
			end

			specify '"or"' do
				new_customer('Paul or Jen Yoder')
				customer_name_values.should_not include('or')
			end
		end
		context 'on multiple attributes' do
			it 'saves name values on each attribute' do
				user = User.create! :first_name => 'Paul', :last_name => 'Yoder'
				user.name_searchables(true).map{|x| x.name.value }.should include('paul', 'yoder')
			end
		end
		context 'when name changes' do
			it 'does not re-add name values that did not change' do
				new_customer('Jen York')
				@customer.name = 'Jen Yoder'
				@customer.save!
				customer_name_values.count('jen').should == 1
			end
			it 'deletes name values that no longer exist' do
				new_customer('Jen York')
				@customer.name = 'Jen Yoder'
				@customer.save!
				customer_name_values(true).should_not include('york')
			end
		end
	end
end
