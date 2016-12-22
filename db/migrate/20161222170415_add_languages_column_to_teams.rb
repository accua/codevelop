class AddLanguagesColumnToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column(:teams, :languages, :string)
  end
end
