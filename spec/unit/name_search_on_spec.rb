require 'spec_helper'

describe NameSearch::NameSearchOn do
  it 'adds full_name_search_on to ActiveRecord::Base class methods' do
    expect(ActiveRecord::Base).to respond_to :name_search_on
  end

  describe 'name_search_on' do

    describe 'name_searchables' do
      it 'adds a polymorphic association to name_searchables' do
        expect(Customer.new).to respond_to :name_searchables
      end
      
      it 'adds a dependent => destroy option to name_searchables' do
        name = Factory :name
        customer = Customer.create!
        searchable = customer.name_searchables.create! :name => name
        customer.destroy
        expect(NameSearch::Searchable.where(:id => searchable.id).count).to eq 0
      end
    end

    context 'after_save callback' do
      it 'calls sync_name_searchables method' do
        expect(
          Customer._save_callbacks.
            select{|x| x.kind == :after && 
                      x.filter == :sync_name_searchables}.
            length
        ).to eq 1
      end

      it 'gets called if the single attribute changes' do
        c = Customer.create! :name => 'Paul'
        expect(c.name_searchables.length).to eq 1
      end
      
      it 'gets called if the last of multiple attributes changes' do
        u = User.create! :first_name => 'Paul', :last_name => 'Yoder'
        u.last_name = 'Smith'
        u.save!
        expect(u.name_searchables.reload.map{|x| x.name.value}).to include('smith')
      end
    end

    it 'adds name_search_attributes class instance variable' do
      expect(Customer).to respond_to :name_search_attributes
    end

    it 'sets name_search_attributes value to the attribute argument' do
      expect(Customer.name_search_attributes).to eq [:name]
      expect(User.name_search_attributes).to eq [:first_name, :last_name]
    end

    it 'adds name_search class method' do
      expect(Customer).to respond_to :name_search
    end
  end
end
