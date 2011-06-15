require 'spec_helper'

describe NameSearch::NickNameFamily do
  it 'should exist' do
    defined?(NameSearch::NickNameFamily).should be_true
  end

  specify 'table name should be name_search_nick_name_families' do
    NameSearch::NickNameFamily.table_name.should == 'name_search_nick_name_families'
  end

  let(:model) { NameSearch::NickNameFamily.new }

  model_responds_to :nick_name_family_joins,
                    :names

  describe '.create_family' do
    it 'uses Name.scrub_and_split_name' do
      family = NameSearch::NickNameFamily.create_family('susan,', 'Miller-smith')
      family.names.map(&:value).should include('susan', 'miller', 'smith')
    end

    it 'returns the NickNameFamily used' do
      family = NameSearch::NickNameFamily.create_family('ben', 'benjamin')
      family.names.map(&:value).should include('ben', 'benjamin')
    end

    context 'when none of the names are in the database' do
      before :all do
        delete_names
        @family = NameSearch::NickNameFamily.create_family('Sue', 'Suzie', 'Susan')
      end
        
      it 'adds all names to the database' do
        find_name('sue').should_not be_nil
        find_name('suzie').should_not be_nil
        find_name('susan').should_not be_nil
      end

      it 'adds all names to the same family' do
        @family.names.map(&:value).should include('sue', 'suzie', 'susan')
      end
    end

    context 'when some names are already in the database but arent in another family' do
      before :all do
        delete_names
        Factory :name, :value => 'joe'
        @family = NameSearch::NickNameFamily.create_family('joseph', 'joey', 'joe')
      end

      it 'adds the other names to the database' do
        find_name('joseph').should_not be_nil
        find_name('joey').should_not be_nil
      end

      it 'all names have the same family' do
        @family.names.map(&:value).should include('joseph', 'joey', 'joe')
      end
    end

    context 'when a name already has a family' do
      before :all do
        delete_names
        @family1 = NameSearch::NickNameFamily.create_family('sam', 'samantha', 'sammy')
        @family2 = NameSearch::NickNameFamily.create_family('sam', 'samuel')
      end

      it 'creates a new family' do
        @family1.id.should_not == @family2.id
      end

      it 'the name is part of both families' do
        find_name('sam').nick_name_family_ids.should include(@family1.id, @family2.id)
      end

      describe 'the unrelated nick names' do
        it 'are not part of the same family' do
          (find_name('samantha').nick_name_family_ids &
           find_name('samuel').nick_name_family_ids).
          length.should == 0
        end
      end
    end
    
    def delete_names
      NameSearch::Name.delete_all
    end

    def find_name(name_or_id)
      NameSearch::Name.find(name_or_id)
    end
  end
end
