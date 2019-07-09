require 'spec_helper'

describe NameSearch::Name do
  it 'should exist' do
    expect(defined?(NameSearch::Name)).to eq 'constant'
  end

  specify 'table name should be name_search_names' do
    expect(NameSearch::Name.table_name).to eq 'name_search_names'
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
    expect(name.value).to eq 'paul'
  end

  describe '#nick_names' do
    it 'returns values for names in same NickNameFamily' do
      NameSearch::NickNameFamily.create_family('andrew', 'andy', 'drew')
      expect(find_name('andy').nick_names.map(&:value)).to include('andrew','andy','drew')
    end
  end

  describe '#nick_name_values' do
    it 'returns the values for names in the same NickNameFamily' do
      NameSearch::NickNameFamily.create_family('andrew', 'andy', 'drew')
      expect(find_name('andrew').nick_name_values).to include('andrew','andy','drew')
    end

    it 'returns empty array if no nick names' do
      delete_names
      NameSearch::Name.create! :value => 'paul'
      expect(find_name('paul').nick_name_values.length).to eq 0
    end
  end

  describe '.excluded_values' do
    context 'includes' do
      it 'and' do
        expect(NameSearch::Name.excluded_values).to include 'and'
      end
      
      it 'or' do
        expect(NameSearch::Name.excluded_values).to include 'or'
      end

      it 'blank string' do
        expect(NameSearch::Name.excluded_values).to include ''
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
        expect(find_name(@name.id).id).to eq @name.id
      end
    end

    context 'when a string argument is used' do
      it 'returns name with same value' do
        expect(find_name('joe').id).to eq @name.id
      end
    end
  end

  describe '.scrub_and_split_name' do
    def scrub_and_split(name)
      NameSearch::Name.scrub_and_split_name(name)
    end

    it 'downcases names' do
      expect(scrub_and_split('Paul')).to include('paul')
    end

    it 'removes non-alphanumeric characters' do
      expect(scrub_and_split('McD8n@ld')).to include('mcd8nld')
    end

    it 'splits on spaces' do
      expect(scrub_and_split('Paul Yoder')).to include('paul', 'yoder')
    end

    it 'splits on hyphens' do
      expect(scrub_and_split('Sue Smith-Miller')).to include('smith', 'miller')
    end

    it 'removes excluded_values' do
      expect(scrub_and_split('Paul and Jen Yoder')).to_not include('and')
    end

    it 'removes duplicate names' do
      expect(scrub_and_split('Paul Paul').length).to eq 1
    end

    it 'removes non-alphanumeric words' do
      expect(scrub_and_split('Paul & Jen').length).to eq 2
    end
  end

  def find_name(name_or_id)
    NameSearch::Name.find(name_or_id)
  end

  def delete_names()
    NameSearch::Name.delete_all
  end
end
