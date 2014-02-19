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

    it 'allows a single array to also be used as the argument' do
      family = NameSearch::NickNameFamily.create_family(['ben', 'benjamin'])
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

  describe '.update_families_from_file' do
    before :all do
      NameSearch::NickNameFamily.delete_all
      NameSearch::Name.delete_all
      NameSearch::NickNameFamilyJoin.delete_all
    end

    after :all do
      NameSearch::NickNameFamily.delete_all
      NameSearch::Name.delete_all
      NameSearch::NickNameFamilyJoin.delete_all
    end

    context 'when valid names' do
      before :all do
        NameSearch::NickNameFamily.create_family('theodore', 'ted')
        NameSearch::NickNameFamily.create_family('samuel', 'sam')
        NameSearch::NickNameFamily.create_family('adam', 'ad')
        NameSearch::NickNameFamily.create_family('adolph', 'ade')
        NameSearch::NickNameFamily.create_family('delbert', 'del')
        NameSearch::NickNameFamily.update_families_from_file(create_names_file)
      end

      after :all do
        delete_names_file
      end

      def create_names_file
        @names_file = Tempfile.new('good_names')
        @names_file.puts 'andrew andy drew'
        @names_file.puts 'theodore teddy ted'
        @names_file.puts 'sam samantha sammie'
        @names_file.puts 'ad ade del adelbert'
        @names_file.flush
        @names_file.path
      end

      def delete_names_file
        @names_file.close!
      end

      context 'when the first name of the row is not part of a nick name family' do
        it 'creates a new family' do
          andrew = NameSearch::Name.where(:value => 'andrew').first
          andrew.nick_name_values.should include('andy', 'drew')
        end
      end

      context 'when only the first name is part of a nick name family' do
        pending 'creates a new family' do
          sam_families = NameSearch::Name.where(:value => 'sam').first.nick_name_families
          sam_families.length.should == 2
          sam_families.any?{|x| (x.names.map(&:value) & ['samuel', 'sam']).length == 2}.should be_true
          sam_families.any?{|x| (x.names.map(&:value) & ['samantha', 'sam', 'sammie']).length == 3}.should be_true
        end
      end

      context 'when the first name and another name is part of the same nick name family' do
        it 'the new names are added to the common nick name family' do
          theodore = NameSearch::Name.where(:value => 'theodore').first
          theodore.nick_name_families.length.should == 1
          theodore.nick_name_values.should include('teddy', 'ted')
        end
      end

      context 'when the names are in 3 or more nick name families' do
        it 'a new nick name family is created' do
          ad_families = NameSearch::Name.where(:value => 'ad').first.nick_name_families
          ad_families.length.should == 2
          ad_families.any?{|x| (x.names.map(&:value) & %w( adam ad )).length == 2}.should be_true
          ad_families.any?{|x| (x.names.map(&:value) & %w( ad ade del adelbert )).length == 4}.should be_true
        end
      end
    end
  end
end
