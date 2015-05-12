class AddAccessTokenToUsers < ActiveRecord::Migration
  def change
    add_column :students, :access_token, :string
  end
end
