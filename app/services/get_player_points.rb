class GetPlayerPoints
  def self.call
    Player.all.each do |player|
      url = 'https://fantasy.premierleague.com/drf/element-summary/' + player.id.to_s
      response = HTTParty.get(url)
      next unless response.ok?

      player_match_history = JSON.parse(response.body)['history']
      player_gameweek_points = JSON.parse(player.gameweek_points)

      player_match_history.each do |m|
        # TODO: change this to work with player_match_history that has two of the same round
        points = m['total_points']

        new_gameweek_points = player_gameweek_points.merge(
          player_gameweek_points[m['round'].to_s] => points,
        )

        player['gameweek_points'] = new_gameweek_points.to_json
        player.save!
      end
    end
  end
end
