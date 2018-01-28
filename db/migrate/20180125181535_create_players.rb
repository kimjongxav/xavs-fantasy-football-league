class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.integer :fantasy_football_id
      t.string :full_name
      t.string :common_name
      t.string :position
      t.references :premier_league_team, foreign_key: true
      (1..38).to_a.map { |i| t.integer "points_in_gameweek_#{i}", default: 0 }

      t.timestamps
    end
    add_index :players, :fantasy_football_id
    add_index :players, :common_name
  end
end
