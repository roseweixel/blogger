class RenameEntriesToPosts < ActiveRecord::Migration
  def change
    rename_table :entries, :posts
  end
end
