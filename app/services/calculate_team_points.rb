class CalculateTeamPoints
  def self.call
    url = 'https://fantasy.premierleague.com/drf/bootstrap-static'
    response = HTTParty.get(url)
    gameweek = JSON.parse(response.body)['current-event']

    Team.all.each do |team|
      players = team.players.where('gameweek_in <= 2 and gameweek_out is null')
      captain = team.players.where(
        'gameweek_in <= 3 and gameweek_out is null and captain_in <= 3 and captain_out is null',
      ).first

      current_gameweek_points = JSON.parse(team.gameweek_points)[gameweek - 1]

    end
  end
end
