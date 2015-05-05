class AddNameToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :name, :string
  end
end
