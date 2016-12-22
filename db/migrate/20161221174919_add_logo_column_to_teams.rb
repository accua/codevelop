class AddLogoColumnToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column(:teams, :logo, :string)
  end
end
