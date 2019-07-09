require 'spec_helper'

describe NameSearch::NameSearchablesConcerns do
  describe 'update_name_searchables' do
    before :all do
      Customer.skip_callback(:save, :after, :sync_name_searchables)
    end

    after :all do
      Customer.set_callback(:save, :after, :sync_name_searchables)
    end

    def new_customer(name)
      @customer = Customer.create! :name => name
      @customer.update_name_searchables
    end

    def customer_name_values(force_reload = false)
      if force_reload
        @customer.name_searchables.reload
      end
      @customer.name_searchables.map{|x| x.name.value }
    end

    specify 'first name' do
      new_customer('Paul')
      expect(customer_name_values).to include('paul')
    end

    specify 'first and last name' do
      new_customer('Paul Yoder')
      expect(customer_name_values).to include('paul', 'yoder')
    end

    specify 'first, spouse and last name' do
      new_customer('Paul and Jen Yoder')
      expect(customer_name_values).to include('paul', 'jen', 'yoder')
    end

    specify 'last, first' do 
      new_customer('Yoder, Paul')
      expect(customer_name_values).to include('paul', 'yoder')
    end

    specify 'hyphenated last name is split in 2' do
      new_customer('Sue Smith-Harrison')
      expect(customer_name_values).to include('sue', 'smith', 'harrison')
    end

    context 'should not include' do
      specify '","' do
        new_customer('Yoder, Paul')
        expect(customer_name_values).to_not include('yoder,')
      end

      specify '";"' do
        new_customer('Paul Yoder;,')
        expect(customer_name_values).to_not include('yoder;,')
        expect(customer_name_values).to include('yoder')
      end

      specify '"and"' do
        new_customer('Paul And Jen Yoder')
        expect(customer_name_values).to_not include('and')
      end

      specify '"&"' do
        new_customer('Paul & Jen Yoder')
        expect(customer_name_values).to_not include('&')
      end

      specify '"or"' do
        new_customer('Paul or Jen Yoder')
        expect(customer_name_values).to_not include('or')
      end
    end
    context 'on multiple attributes' do
      it 'saves name values on each attribute' do
        user = User.create! :first_name => 'Paul', :last_name => 'Yoder'
        expect(user.name_searchables.reload.map{|x| x.name.value }).to include('paul', 'yoder')
      end
    end
    context 'when name changes' do
      it 'does not re-add name values that did not change' do
        new_customer('Jen York')
        @customer.name = 'Jen Yoder'
        @customer.update_name_searchables
        expect(customer_name_values.count('jen')).to eq 1
      end
      it 'deletes name values that no longer exist' do
        new_customer('Jen York')
        @customer.name = 'Jen Yoder'
        @customer.update_name_searchables
        expect(customer_name_values(true)).to_not include('york')
      end
    end
  end

  describe 'sync_name_searchables' do
    it 'is set as an after save callback' do
      expect(
        Customer._save_callbacks.any?{|callback| callback.kind == :after &&
                                                callback.filter == :sync_name_searchables}
        
      ).to eq true
    end
  end

  describe 'name_search_attributes_changed?' do
    it 'returns true when a name_search attribute is changed' do
      customer = Customer.create! :name => 'Paul'
      customer.name = 'Ben'
      customer.save
      expect(customer.name_search_attributes_changed?()).to eq true
    end
    it 'returns false when a name_search attribute is not changed' do
      customer = Customer.create! :name => 'Paul', :state => 'IN'
      customer.state = 'NE'
      customer.save
      expect(customer.name_search_attributes_changed?()).to eq false
    end
  end

  describe 'name_searchable_values' do
    it 'maps name_searchbles.name.value' do
      c = Customer.create! :name => 'Paul Yoder'
      expect(c.name_searchable_values).to include('paul', 'yoder')
    end
  end
end
