require 'name_search'
require 'rails'

module NameSearch
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'name_search/railties/tasks.rake'
    end
  end
end
