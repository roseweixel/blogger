class ChangeRotationSetToRotationLockedInSchedules < ActiveRecord::Migration
  def change
    rename_column :schedules, :rotation_set, :rotation_locked
  end
end
