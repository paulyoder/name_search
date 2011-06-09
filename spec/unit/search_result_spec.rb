require 'spec_helper'

describe NameSearch::SearchResult do
	let(:customer) { Customer.create! :name => 'Billy Joe Bob' }
	let(:model) { NameSearch::SearchResult.new(customer, ['paul'], []) }

	model_responds_to :model,
										:matched_names,
										:exact_name_matches,
										:nick_name_matches,
										:match_score
	
	describe '.initialize' do
		pending 'write some tests'

	end
end
