require 'spec_helper'

describe NameSearch::Name do
	it 'should exist' do
		defined?(NameSearch::Name).should be_true
	end

	specify 'table name should be name_search_names' do
		NameSearch::Name.table_name.should == 'name_search_names'
	end

	let(:model) { Factory.build :name }

	model_responds_to :value,
									  :nick_name_family,
										:nick_names,
										:nick_name_values
	
	model_has_unique_attributes :value

	it 'always saves name values in downcase' do
		NameSearch::Name.delete_all
		name = Factory :name, :value => 'Paul'
		name.reload
		name.value.should == 'paul'
	end

	describe '#nick_names' do
		it 'returns values for names in same NickNameFamily' do
			NameSearch::Name.relate_nick_names('andrew', 'andy', 'drew')
			find_name('andy').nick_names.map(&:value).should include('andrew','andy','drew')
		end
	end

	describe '#nick_name_values' do
		it 'returns the values for names in the same NickNameFamily' do
			NameSearch::Name.relate_nick_names('andrew', 'andy', 'drew')
			find_name('andrew').nick_name_values.should include('andrew','andy','drew')
		end
		it 'returns empty array if no nick names' do
			delete_names
			NameSearch::Name.create! :value => 'paul'
			find_name('paul').nick_name_values.length.should == 0
		end
	end

	describe '.excluded_values' do
		context 'includes' do
			it 'and' do
				NameSearch::Name.excluded_values.should include 'and'
			end
			it '&' do
				NameSearch::Name.excluded_values.should include '&'
			end
			it 'or' do
				NameSearch::Name.excluded_values.should include 'or'
			end
		end
	end

	describe '.find' do
		before :all do
			delete_names
			@name = NameSearch::Name.create! :value => 'joe'
		end
		context 'when an integer argument is used' do
			it 'returns name with same id' do
				find_name(@name.id).id.should == @name.id
			end
		end
		context 'when a string argument is used' do
			it 'returns name with same value' do
				find_name('joe').id.should == @name.id
			end
		end
	end

	describe '.relate_nick_names' do
		context 'when none of the names are in the database' do
			before :all do
				delete_names
				NameSearch::Name.relate_nick_names('Sue', 'Suzie', 'Susan')
			end
				
			it 'adds all names to the database' do
				find_name('sue').should_not be_nil
				find_name('suzie').should_not be_nil
				find_name('susan').should_not be_nil
			end

			it 'all names have the same family' do
				sue_relationship_id = find_name('sue').try(:nick_name_family_id)
				suzie_relationship_id = find_name('suzie').try(:nick_name_family_id)
				susan_relationship_id = find_name('susan').try(:nick_name_family_id)
				sue_relationship_id.should_not be_nil
				suzie_relationship_id.should_not be_nil
				susan_relationship_id.should_not be_nil
				sue_relationship_id.should == suzie_relationship_id
				sue_relationship_id.should == susan_relationship_id
			end
		end

		context 'when some names are already in the database' do
			before :all do
				delete_names
				Factory :name, :value => 'joe'
				NameSearch::Name.relate_nick_names('joseph', 'joey', 'joe')
			end

			it 'adds the other names to the database' do
				find_name('joseph').should_not be_nil
				find_name('joey').should_not be_nil
			end

			it 'all names have the same family' do
				family = find_name('joseph').nick_name_family
				find_name('joey').nick_name_family.should == family
				find_name('joe').nick_name_family.should == family
			end
		end

		context 'when a name already has a nick_name_family' do
			before :all do
				delete_names
				@family = Factory :nick_name_family
				Factory :name, :value => 'Joe', :nick_name_family => @family
				NameSearch::Name.relate_nick_names('Joseph', 'Joey', 'Joe')
			end

			it 'finds the nick_name_family even if argument name is not downcased' do
				find_name('joey').nick_name_family.should == @family
			end

			it 'the other names receive the same nick_name_family' do
				find_name('joseph').nick_name_family.should == @family
				find_name('joey').nick_name_family.should == @family
				find_name('joe').nick_name_family.should == @family
			end
		end
	end

	def find_name(name_or_id)
		NameSearch::Name.find(name_or_id)
	end

	def delete_names()
		NameSearch::Name.delete_all
	end
end
