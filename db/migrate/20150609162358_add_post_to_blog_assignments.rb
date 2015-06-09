class AddPostToBlogAssignments < ActiveRecord::Migration
  def change
    add_column :blog_assignments, :post_id, :integer
  end
end
