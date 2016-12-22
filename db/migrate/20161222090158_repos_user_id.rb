class ReposUserId < ActiveRecord::Migration[5.0]
  def change
    add_column(:repos, :user_id, :integer)
  end
end
