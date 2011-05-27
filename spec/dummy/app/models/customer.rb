class Customer < ActiveRecord::Base
  attr_accessible :name, :state, :zip

  full_name_search_on :name
end
