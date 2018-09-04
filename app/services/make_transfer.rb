class MakeTransfer
  def self.call(team, player_out_id, player_in_id, new_captain_id = nil)
    gameweek = GetGameweek.call
    relation = PlayerTeamRelationship.
               where(:team_id => team.id, :player_id => player_out_id).
               max_by { |h| h[:gameweek_in] }

    relation.gameweek_out = gameweek
    relation.save!

    PlayerTeamRelationship.create!(
      :player_id => player_in_id,
      :team_id => team.id,
      :gameweek_in => gameweek,
    )

    if new_captain_id
      new_captain =
        PlayerTeamRelationship.
        where(:team_id => team.id, :player_id => new_captain_id).
        max_by { |h| h[:gameweek_in] }

      new_captain.gameweek_out = gameweek

      PlayerTeamRelationship.create!(
        :player_id => new_captain_id,
        :team_id => team.id,
        :gameweek_in => gameweek,
        :captain => true,
      )
    end

    team.transfers_remaining -= 1
    team.save!
  end
end
