class RemoveUserIdFromComments < ActiveRecord::Migration[5.0]
  def change
    remove_column(:comments, :user_id, :integer)
  end
end
