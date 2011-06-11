require 'spec_helper'

describe NameSearch::Search do
	it 'should exist' do
		defined?(NameSearch::Search).should be_true
	end	

	it 'should inherit from Array' do
		NameSearch::Search.ancestors.second.should == Array
	end

	describe '.initialize' do
		def search(klass, name, options = {})
			NameSearch::Search.new(klass, name, options)
		end

		before :all do
			Customer.destroy_all
			Customer.create! :name => 'Paul'
			Customer.create! :name => 'Paul'
			Customer.create! :name => 'Ben Miller'
			Customer.create! :name => 'Ben Miller', :state => 'NE'
			Customer.create! :name => 'Benjamin', :state => 'NE'
			Customer.create! :name => 'Fred Flintstone'
			Customer.create! :name => 'Fred Smith'
			Customer.create! :name => 'Fred Samuel Smith'

			NameSearch::Name.relate_nick_names('benjamin', 'ben')
		end
			
		context 'single name' do
			it 'should return models with exact same names' do
				results = search(Customer, 'paul')
				results.select{|x| x.model.name == 'Paul'}.length.should == 2
			end
		end

		context 'multiple names' do
			it 'should return models with exact same names' do
				results = search(Customer, 'ben miller')
				results.select{|x| x.model.name == 'Ben Miller'}.length.should == 2
			end

			it 'should return models with same first name' do
				results = search(Customer, 'fred')
				results.select{|x| x.model.name =~ /Fred/}.length.should == 3
			end

			it 'should sort returned models by number of name matches' do
				results = search(Customer, 'Fred Samuel Smith')
				results.length.should == 3
				results.index{|x| x.model.name == 'Fred Samuel Smith'}.should == 0
			end
		end

		context 'nicknames' do
			it 'should return models in same nick name family' do
				search(Customer, 'ben').select{|x| x.model.name == 'Benjamin'}.length.should == 1
			end

			it 'should return exact matches before nick name matches' do
				results = search(Customer, 'benjamin')
				ben_result_index = results.index{|x| x.model.name == 'Ben Miller'}
				benjamin_result_index = results.index{|x| x.model.name == 'Benjamin'}
				benjamin_result_index.should be < ben_result_index
			end
    end

    context 'search results' do
      context 'exact_name_matches' do
        it 'should include searched names that match' do
          search(Customer, 'benjamin').map(&:exact_name_matches).flatten.should include('benjamin')
        end

        it 'should not include searched nick names' do
          search(Customer, 'benjamin').map(&:exact_name_matches).flatten.should_not include('ben')
        end
      end

      context 'nick_name_matches' do
        it 'should include nick names' do
          search(Customer, 'benjamin').map(&:nick_name_matches).flatten.should include('ben')
        end

        it 'should not include searched names' do
          search(Customer, 'benjamin').map(&:nick_name_matches).flatten.should_not include('benjamin')
        end
      end
		end

		context 'should parse the names argument correctly' do
			it 'should filter out non-alpha-numeric characters' do
				results = search(Customer, 'miller,')
				results.select{|x| x.model.name =~ /Miller/}.length.should == 2
			end
		end

		describe 'options' do
      describe 'matches_at_least' do
        context 'when 2' do
          it 'should bring back models with 2 or more name matches' do
            results = search(Customer, 'benjamin miller', :matches_at_least => 2)
            results.length.should == 2
            results.first.matched_names.length.should be >= 2
            results.second.matched_names.length.should be >= 2
          end
        end
      end
      describe 'match_mode' do
        context ':exact' do
          it 'does not search on nick names' do
            results = search(Customer, 'benjamin', :match_mode => :exact)
            results.map(&:nick_name_matches).flatten.length.should == 0
          end
        end
      end
		end

    describe 'klass_or_query' do
      describe 'query' do
        it 'only searches on models in within the query' do
          search(Customer.where(:state => 'NE'), 'ben').length.should == 2
        end
      end
    end
	end
end
