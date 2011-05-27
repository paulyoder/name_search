class CreatePersonSearchTables < ActiveRecord::Migration
  def self.up
    create_table :person_search_names do |t|
      t.string  :value
      t.integer :nick_name_family_id
    end
    add_index :person_search_names, :value
    add_index :person_search_names, :nick_name_family_id
     
    create_table :person_search_nick_name_families do |t|
    end

    create_table :person_search_name_searchables do |t|
      t.integer :name_id
      t.integer :searchable_id
			t.string	:searchable_type
    end
    add_index :person_search_name_searchables, :name_id
    add_index :person_search_name_searchables,
			[:searchable_id, :searchable_type],
			:name => 'index_person_search_searchable'
  end

  def self.down
    drop_table :person_search_names
    drop_table :person_search_nick_name_families
    drop_table :person_search_name_searchables
  end
end
