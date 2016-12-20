class AddIds < ActiveRecord::Migration[5.0]
  def change
    add_column(:comments, :user_id, :integer)
    add_column(:followers, :user_id, :integer)
    add_column(:followings, :user_id, :integer)
  end
end
