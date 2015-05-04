class AddStudentToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :student_id, :integer
  end
end
