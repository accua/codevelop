class ChangeLanguageSkillsTableToSkills < ActiveRecord::Migration[5.0]
  def change
    rename_table(:language_skills, :skills)
  end
end
