class CreateNameSearchTables < ActiveRecord::Migration
  def self.up
    create_table :name_search_names do |t|
      t.string  :value
    end
    add_index :name_search_names, :value

    create_table :name_search_nick_name_family_joins do |t|
      t.integer :name_id
      t.integer :nick_name_family_id
    end
    add_index :name_search_nick_name_family_joins, :name_id
    add_index :name_search_nick_name_family_joins, :nick_name_family_id, name: 'index_name_search_nick_name_family_joins_on_nick_name_family'
     
    create_table :name_search_nick_name_families do |t|
    end

    create_table :name_search_searchables do |t|
      t.integer :name_id
      t.integer :searchable_id
      t.string  :searchable_type
    end
    add_index :name_search_searchables, :name_id
    add_index :name_search_searchables,
      [:searchable_id, :searchable_type],
      :name => 'index_name_search_searchable'
  end

  def self.down
    drop_table :name_search_names
    drop_table :name_search_nick_name_family_joins
    drop_table :name_search_nick_name_families
    drop_table :name_search_searchables
  end
end
