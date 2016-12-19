class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table(:posts_teams) do |pt|
      pt.integer :team_id
      pt.integer :post_id
      pt.integer :posted_by

      pt.timestamps
    end
    create_table(:teams) do |t|
      t.string :name
      t.text :team_info

      t.timestamps
    end
    create_table(:posts) do |po|
      po.text :content

      po.timestamps
    end
    create_table(:posts_users) do |pu|
      pu.integer :post_id
      pu.integer :user_id

      pu.timestamps
    end
    create_table(:comments) do |c|
      c.text :content
      c.integer :post_id
      c.integer :user_id

      c.timestamps
    end
    create_table(:followers) do |fr|
      fr.integer :follower_id

      fr.timestamps
    end
    create_table(:followings) do |fi|
      fi.integer :following_id

      fi.timestamps
    end
    create_table(:teams_users) do |tu|
      tu.integer :team_id
      tu.integer :user_id

      tu.timestamps
    end
    create_table(:users) do |u|
      u.string :user_name
      u.string :profile_picture
      u.text :bio
      u.string :experience_level
      u.text :job_history
      u.boolean :online

      u.timestamps
    end
    create_table(:language_skills) do |ls|
      ls.integer :user_id
      ls.integer :language_id
      ls.integer :rating

      ls.timestamps
    end
    create_table(:team_messages) do |tm|
      tm.integer :team_id
      tm.integer :message_id
      tm.integer :sender_id

      tm.timestamps
    end
    create_table(:messages_users) do |mu|
      mu.integer :user_id
      mu.integer :message_id

      mu.timestamps
    end
    create_table(:languages) do |l|
      l.string :name
      l.string :icon

      l.timestamps
    end
    create_table(:messages) do |m|
      m.text :content
      m.integer :sender_id
      m.integer :receiver_id

      m.timestamps
    end
  end
end
