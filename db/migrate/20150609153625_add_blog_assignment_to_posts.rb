class AddBlogAssignmentToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :blog_assignment_id, :integer
  end
end
