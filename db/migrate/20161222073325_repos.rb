class Repos < ActiveRecord::Migration[5.0]
  def change
    create_table(:repos) do |r|
      r.string :name
      r.string :url
      r.string :language

      r.timestamps
    end
  end
end
