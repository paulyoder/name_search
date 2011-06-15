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
                    :nick_name_family_joins,
                    :nick_name_families,
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
      NameSearch::NickNameFamily.create_family('andrew', 'andy', 'drew')
      find_name('andy').nick_names.map(&:value).should include('andrew','andy','drew')
    end
  end

  describe '#nick_name_values' do
    it 'returns the values for names in the same NickNameFamily' do
      NameSearch::NickNameFamily.create_family('andrew', 'andy', 'drew')
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

  describe '.scrub_and_split_name' do
    def scrub_and_split(name)
      NameSearch::Name.scrub_and_split_name(name)
    end

    it 'downcases names' do
      scrub_and_split('Paul').should include('paul')
    end

    it 'removes non-alphanumeric characters' do
      scrub_and_split('McD8n@ld').should include('mcd8nld')
    end

    it 'splits on spaces' do
      scrub_and_split('Paul Yoder').should include('paul', 'yoder')
    end

    it 'splits on hyphens' do
      scrub_and_split('Sue Smith-Miller').should include('smith', 'miller')
    end

    it 'removes excluded_values' do
      scrub_and_split('Paul and Jen Yoder').should_not include('and')
    end

    it 'removes duplicate names' do
      scrub_and_split('Paul Paul').length.should == 1
    end
  end

  def find_name(name_or_id)
    NameSearch::Name.find(name_or_id)
  end

  def delete_names()
    NameSearch::Name.delete_all
  end
end
