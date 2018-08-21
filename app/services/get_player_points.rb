class GetPlayerPoints
  def self.call
    Player.all.each do |player|
      url = 'https://fantasy.premierleague.com/drf/element-summary/' + player.id.to_s
      response = HTTParty.get(url)
      next unless response.ok?

      player_match_history = JSON.parse(response.body)['history']

      updated_history = player_match_history.map do |m|
        points = m['total_points']
        round = m['round']

        { round => points }
      end

      merged_history = updated_history.inject do |round, points|
        round.merge(points) { |_, old_v, new_v| old_v + new_v }
      end

      player['gameweek_points'] = merged_history
      player.save!
    end
  end
end
