class UpdatePost < ActiveRecord::Migration[5.0]
  def change
    drop_table :posts_users
    add_column(:posts, :user_id, :integer)
  end
end
