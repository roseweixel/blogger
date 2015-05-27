class RemoveScheduleFromHolidays < ActiveRecord::Migration
  def change
    remove_column :holidays, :schedule_id
  end
end
