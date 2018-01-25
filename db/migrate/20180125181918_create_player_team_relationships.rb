class CreatePlayerTeamRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :player_team_relationships do |t|
      t.integer :player_id
      t.integer :team_id
      t.integer :gameweek_in
      t.integer :gameweek_out
      t.boolean :captain_in
      t.boolean :captain_out

      t.timestamps
    end
    add_index :player_team_relationships, :player_id
    add_index :player_team_relationships, :team_id
    add_index :player_team_relationships, %i[player_id team_id], unique: true
  end
end
