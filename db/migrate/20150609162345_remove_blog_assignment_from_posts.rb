class RemoveBlogAssignmentFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :blog_assignment_id
  end
end
