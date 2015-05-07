class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :blog_id
      t.string :title
      t.datetime :published_date
      t.string :url
      t.timestamps null: false
    end
  end
end
