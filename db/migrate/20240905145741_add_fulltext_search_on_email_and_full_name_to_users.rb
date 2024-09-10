class AddFulltextSearchOnEmailAndFullNameToUsers < ActiveRecord::Migration[7.2]

  disable_ddl_transaction!

  def up
    safety_assured do
      execute <<-SQL.squish
      CREATE INDEX CONCURRENTLY index_on_users_fulltext_search
      ON users
      USING gin ((lower(full_name) || ' ' || lower(email)) gin_trgm_ops);
      SQL
    end
  end

  def down
    remove_index :users, name: :index_on_users_fulltext_search
  end

end
