class RemoveCohortIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :cohort_id
  end
end
