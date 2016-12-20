class AddReadToMessageAndPasswordToUser < ActiveRecord::Migration[5.0]
  def change
    add_column(:messages, :read, :boolean)
    add_column(:users, :password, :string)
  end
end
