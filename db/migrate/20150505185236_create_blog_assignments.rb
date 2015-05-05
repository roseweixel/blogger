class CreateBlogAssignments < ActiveRecord::Migration
  def change
    create_table :blog_assignments do |t|
      t.integer :student_id
      t.date :due_date
      t.timestamps null: false
    end
  end
end
