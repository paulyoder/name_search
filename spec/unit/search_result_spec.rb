require 'spec_helper'

describe NameSearch::SearchResult do
	let(:customer) { Customer.create! :name => 'Billy Joe Bob' }
	let(:model) { NameSearch::SearchResult.new(customer, [], []) }
  let(:subject) { NameSearch::SearchResult.new(customer,
                                               %w( william joe robert henry), 
                                               %w( bill billy joseph jo bob )) }

	model_responds_to :model,
										:matched_names,
										:exact_name_matches,
										:nick_name_matches,
										:match_score

  it 'should set first argument as model attribute' do
    subject.model.should == customer
  end

  describe '#exact_name_matches' do
    it 'should be names that match between name_searchable_values and searched_names' do
      subject.exact_name_matches.should == ['joe']
    end
  end

  describe '#nick_name_matches' do
    it 'should be names that match between name_searchable_values and searched_nick_names' do
      subject.nick_name_matches.should == ['billy', 'bob']
    end
  end

  describe '#matched_names' do
    it 'should include name_searchable_values that were matched on' do
      subject.matched_names.should == ['joe', 'billy', 'bob']
    end
  end

  describe '#match_score' do
    def result(customer_name, searched_names, searched_nick_names)
      NameSearch::SearchResult.new(Customer.create!({:name => customer_name}),
                                   searched_names,
                                   searched_nick_names)
    end

    it 'should add 2 for every exact_name_match' do
      result('Paul',['paul'],[]).match_score.should == 2
    end 

    it 'should add 1 for every nick_name_match' do
      result('Benjamin Joe', [], ['benjamin']).match_score.should == 1
    end

    context 'when 2 exact_name_matches and 1 nick_name_match' do
      it 'should be 5' do
        result('Billy Joe Bob', ['billy', 'joe'], ['bob']).match_score.should == 5
      end
    end
  end
end
