class AddScheduleToBlogAssignments < ActiveRecord::Migration
  def change
    add_column :blog_assignments, :schedule_id, :integer
  end
end
