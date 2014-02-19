class User < ActiveRecord::Base
  name_search_on :first_name, :last_name
end
