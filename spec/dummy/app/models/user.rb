class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name

  name_search_on :first_name, :last_name
end
