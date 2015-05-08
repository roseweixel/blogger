class AddRotationSetToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :rotation_set, :boolean, default: false
  end
end
