class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :transfers_remaining, default: 3
      t.string :properties # this will be a string in the style of json
      t.references :user, foreign_key: true
      t.references :league, foreign_key: true
      (1..38).to_a.map { |i| t.integer "points_in_gameweek_#{i}", default: 0 }

      t.timestamps
    end
    add_index :teams, :user_id
    add_index :teams, :league_id
  end
end
