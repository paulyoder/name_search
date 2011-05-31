class Customer < ActiveRecord::Base
  attr_accessible :name, :state, :zip

  name_search_on :name
end
