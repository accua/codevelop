class RemoveUserIds < ActiveRecord::Migration[5.0]
  def change
    remove_column(:comments, :user_id, :integer)
    remove_column(:followers, :user_id, :integer)
    remove_column(:followings, :user_id, :integer)
  end
end
