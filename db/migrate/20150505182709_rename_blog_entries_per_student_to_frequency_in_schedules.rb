class RenameBlogEntriesPerStudentToFrequencyInSchedules < ActiveRecord::Migration
  def change
    rename_column :schedules, :blog_entries_per_student, :frequency
  end
end
