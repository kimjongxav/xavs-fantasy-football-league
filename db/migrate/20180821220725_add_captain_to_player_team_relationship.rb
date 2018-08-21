class AddCaptainToPlayerTeamRelationship < ActiveRecord::Migration[5.1]
  def up
    remove_column :player_team_relationships, :captain_in
    remove_column :player_team_relationships, :captain_out
    add_column :player_team_relationships, :captain, :boolean, :default => false
  end

  def down
    remove_column :player_team_relationships, :captain
    add_column :player_team_relationships, :captain_in, :boolean, :default => false
    add_column :player_team_relationships, :captain_out, :boolean, :default => false
end
end
