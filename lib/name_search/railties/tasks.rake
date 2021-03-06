namespace :name_search do
  desc 'runs the update_name_searchables() method on all records of the class'
  task :update_name_searchables, [:model, :page_size] => :environment do |t, args|
    klass = args[:model].camelize.constantize
    page_size = args[:page_size].try(:to_i) || 100
    page = 0
    
    record_count = klass.count
    records = klass.offset(page * page_size).limit(page_size)
    while records.length > 0
      records.each{|x| x.update_name_searchables}
      page += 1
      puts "Updated #{page * page_size} of #{record_count}"
      records = klass.offset(page * page_size).limit(page_size)
    end
    puts 'finished'
  end

  desc 'adds the 1990 census nick names to the database (http://www.censusdiggins.com/nicknames.htm)'
  task :add_census_nick_names => :environment do
    census_file = File.expand_path('../../../assets/census_nick_names.txt', __FILE__)
    NameSearch::NickNameFamily.update_families_from_file(census_file)
  end

  desc 'adds the contributed nick names to the database'
  task :add_contributed_nick_names => :environment do
    nick_name_file = File.expand_path('../../../assets/contributed_nick_names.txt', __FILE__)
    NameSearch::NickNameFamily.update_families_from_file(nick_name_file)
  end
end
