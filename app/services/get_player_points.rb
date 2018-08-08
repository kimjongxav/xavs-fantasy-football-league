class GetPlayerPoints
  def self.call
    Player.all.each do |player|
      url = 'https://fantasy.premierleague.com/drf/element-summary/' + player.id.to_s
      response = HTTParty.get(url)
      next unless response.ok?

      player_match_history = JSON.parse(response.body)['history']
      gameweek_history = {}

      player_match_history.each do |m|
        current_score = gameweek_history[m['round']] || 0
        gameweek_history[m['round']] = m['total_points'] += current_score
      end
    end
  end
end
