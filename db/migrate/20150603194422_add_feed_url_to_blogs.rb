class AddFeedUrlToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :feed_url, :string
  end
end
