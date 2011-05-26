require 'spec_helper'

describe PersonSearch::Name do
	it 'should exist' do
		defined?(PersonSearch::Name).should be_true
	end

	specify 'table name should be person_search_names' do
		PersonSearch::Name.table_name.should == 'person_search_names'
	end

	let(:model) { Factory.build :name }

	model_responds_to :value,
									  :family
	
	model_has_unique_attributes :value

	context '.add_nick_name' do
		context 'when neither name is in the database' do
			before :all do
				PersonSearch::Name.delete_all
				PersonSearch::Name.add_nick_name('Sue', 'Suzie')
			end
				
			it 'adds both names to the database' do
				PersonSearch::Name.where(:value => 'Sue').count.should == 1
				PersonSearch::Name.where(:value => 'Suzie').count.should == 1
			end

			it 'both names have the same family' do
				sue_relationship_id = PersonSearch::Name.where(:value => 'Sue').first.try(:family_id)
				suzie_relationship_id = PersonSearch::Name.where(:value => 'Suzie').first.try(:family_id)
				sue_relationship_id.should_not be_nil
				suzie_relationship_id.should_not be_nil
				sue_relationship_id.should == suzie_relationship_id
			end
		end

		context 'when first name is in the database' do
			it 'adds the second name to the database'
			it 'both names have the same family'
		end
	end
end
