class Customer < ActiveRecord::Base
  name_search_on :name
end
