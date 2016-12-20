class ChangeTeamMessageName < ActiveRecord::Migration[5.0]
  def change
    rename_table(:posts_teams, :team_posts)
  end
end
