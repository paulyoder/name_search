require 'spec_helper'

describe NameSearch::Search do
	it 'should exist' do
		defined?(NameSearch::Search).should be_true
	end	

	it 'should inherit from Array' do
		NameSearch::Search.ancestors.second.should == Array
	end

	describe '.initialize' do
		def search(klass, name)
			NameSearch::Search.new(klass, name)
		end

		before :all do
			Customer.destroy_all
			Customer.create! :name => 'Paul'
			Customer.create! :name => 'Paul'
			Customer.create! :name => 'Ben Miller'
			Customer.create! :name => 'Ben Miller'
			Customer.create! :name => 'Fred Flintstone'
			Customer.create! :name => 'Fred Smith'
		end
			
		context 'single name' do
			it 'should return models with exact same names' do
				results = search(Customer, 'paul')
				results.select{|x| x.name == 'Paul'}.length.should == 2
			end
		end

		context 'multiple names' do
			it 'should return models with exact same names' do
				results = search(Customer, 'ben miller')
				results.select{|x| x.name == 'Ben Miller'}.length.should == 2
			end

			it 'should return models with same first name' do
				results = search(Customer, 'fred')
				results.select{|x| x.name =~ /Fred/}.length.should == 2
			end
		end

		it 'should parse the names argument correctly'
	end
end
