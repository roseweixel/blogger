class RemoveNameFromStudents < ActiveRecord::Migration
  def change
    remove_column :students, :name
  end
end
