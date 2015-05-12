class ChangeStudentIdToUserId < ActiveRecord::Migration
  def change
    rename_column :blogs, :student_id, :user_id
    rename_column :blog_assignments, :student_id, :user_id
  end
end
