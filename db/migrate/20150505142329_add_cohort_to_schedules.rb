class AddCohortToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :cohort_id, :integer
  end
end
