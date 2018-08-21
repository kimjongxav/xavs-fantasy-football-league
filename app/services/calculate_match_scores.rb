class CalculateMatchScores
  def self.call
    url = 'https://fantasy.premierleague.com/drf/bootstrap-static'
    response = HTTParty.get(url)
    gameweek = JSON.parse(response.body)['current-event']

    matches = Match.where(:gameweek => gameweek)

    matches.each do |match|
      home_team_score = 0
      away_team_score = 0

      home_team = match.home_team
      away_team = match.away_team

      home_team_points = calculate_points(home_team, gameweek)
      away_team_points = calculate_points(away_team, gameweek)

      puts "home team: #{home_team.id} (#{home_team_points})"
      puts "away team: #{away_team.id} (#{away_team_points})"

      if home_team_points == away_team_points
        home_team_score += 2
        away_team_score += 2

        home_team_props = JSON.parse(home_team.properties)
        away_team_props = JSON.parse(away_team.properties)

        home_draws = home_team_props['draws'] += 1
        away_draws = away_team_props['draws'] += 1

        home_team_props['draws'] = home_draws
        away_team_props['draws'] = away_draws

        home_team.properties = home_team_props.to_json
        home_team.save!

        away_team.properties = away_team_props.to_json
        away_team.save!
      elsif home_team_points > away_team_points
        home_team_score += 4
        away_team_score += 1 if (home_team_points - away_team_points) <= 5

        home_team_props = JSON.parse(home_team.properties)
        away_team_props = JSON.parse(away_team.properties)

        wins = home_team_props['wins'] += 1
        losses = away_team_props['losses'] += 1

        home_team_props['wins'] = wins
        away_team_props['losses'] = losses

        home_team.properties = home_team_props.to_json
        home_team.save!

        away_team.properties = away_team_props.to_json
        away_team.save!
      elsif home_team_points < away_team_points
        away_team_score += 4
        home_team_score += 1 if (away_team_points - home_team_points) <= 5

        home_team_props = JSON.parse(home_team.properties)
        away_team_props = JSON.parse(away_team.properties)

        losses = home_team_props['losses'] += 1
        wins = away_team_props['wins'] += 1

        home_team_props['losses'] = losses
        away_team_props['wins'] = wins

        home_team.properties = home_team_props.to_json
        home_team.save!

        away_team.properties = away_team_props.to_json
        away_team.save!
      end

      match.update!(
        :home_score => home_team_score,
        :away_score => away_team_score,
        :home_points => home_team_points,
        :away_points => away_team_points,
        :played => true,
      )

      home_team_gameweek_scores = JSON.parse(home_team.gameweek_scores)
      away_team_gameweek_scores = JSON.parse(away_team.gameweek_scores)

      home_team_gameweek_scores[gameweek.to_s] = home_team_score
      away_team_gameweek_scores[gameweek.to_s] = away_team_score

      home_team.gameweek_scores = home_team_gameweek_scores.to_json
      home_team.save!

      away_team.gameweek_scores = away_team_gameweek_scores.to_json
      away_team.save!
    end

    update_scores(gameweek)
  end

  def self.update_scores(gameweek)
    matches = Match.where(:gameweek => gameweek)
    team_points = {}
    matches.each do |m|
      team_points[m['home_team_id']] = m['home_points']
      team_points[m['away_team_id']] = m['away_points']
    end

    most_points_teams = team_points.each { |k, v| k if v == team_points.values.max }.compact
    fewest_points_teams = team_points.each { |k, v| k if v == team_points.values.min }.compact
    over_sixty_teams = team_points.map { |k, v| k if v > 60 }.compact

    matches.each do |m|
      if most_points_teams.include?(m['home_team_id'])
        score = m['home_score']
        score += 1
        m.update!(:home_score => score)

        home_team_props = JSON.parse(home_team.properties)
        home_team_scores = JSON.parse(home_team.gameweek_scores)
        top_weekly = home_team_props['top_weekly'] += 1
        new_score = home_team_scores[gameweek.to_s] += 1
        home_team_props['top_weekly'] = top_weekly
        home_team_scores[gameweek.to_s] = new_score
        home_team.properties = home_team_props.to_json
        home_team.gameweek_scores = home_team_scores.to_json
        home_team.save!
      end
      if most_points_teams.include?(m['away_team_id'])
        score = m['away_score']
        score += 1
        m.update!(:away_score => score)

        away_team_props = JSON.parse(away_team.properties)
        away_team_scores = JSON.parse(away_team.gameweek_scores)
        top_weekly = away_team_props['top_weekly'] += 1
        new_score = away_team_scores[gameweek.to_s] += 1
        away_team_props['top_weekly'] = top_weekly
        away_team_scores[gameweek.to_s] = new_score
        away_team.properties = away_team_props.to_json
        away_team.gameweek_scores = away_team_scores.to_json
        away_team.save!
      end
      if fewest_points_teams.include?(m['home_team_id'])
        score = m['home_score']
        score -= 1
        m.update!(:home_score => score)

        home_team_props = JSON.parse(home_team.properties)
        home_team_scores = JSON.parse(home_team.gameweek_scores)
        bottom_weekly = home_team_props['bottom_weekly'] += 1
        new_score = home_team_scores[gameweek.to_s] -= 1
        home_team_props['bottom_weekly'] = bottom_weekly
        home_team_scores[gameweek.to_s] = new_score
        home_team.properties = home_team_props.to_json
        home_team.gameweek_scores = home_team_scores.to_json
        home_team.save!
      end
      if fewest_points_teams.include?(m['away_team_id'])
        score = m['away_score']
        score -= 1
        m.update!(:away_score => score)

        away_team_props = JSON.parse(away_team.properties)
        away_team_scores = JSON.parse(away_team.gameweek_scores)
        bottom_weekly = away_team_props['bottom_weekly'] += 1
        new_score = away_team_scores[gameweek.to_s] -= 1
        away_team_props['bottom_weekly'] = bottom_weekly
        away_team_scores[gameweek.to_s] = new_score
        away_team.properties = away_team_props.to_json
        away_team.gameweek_scores = away_team_scores.to_json
        away_team.save!
      end
      if over_sixty_teams.include?(m['home_team_id'])
        score = m['home_score']
        score += 1
        m.update!(:home_score => score)

        home_team_props = JSON.parse(home_team.properties)
        home_team_scores = JSON.parse(home_team.gameweek_scores)
        bottom_weekly = home_team_props['over_sixty'] += 1
        new_score = home_team_scores[gameweek.to_s] += 1
        home_team_props['over_sixty'] = bottom_weekly
        home_team_scores[gameweek.to_s] = new_score
        home_team.properties = home_team_props.to_json
        home_team.gameweek_scores = home_team_scores.to_json
        home_team.save!
      end
      if over_sixty_teams.include?(m['away_team_id'])
        score = m['away_score']
        score += 1
        m.update!(:away_score => score)

        away_team_props = JSON.parse(away_team.properties)
        away_team_scores = JSON.parse(away_team.gameweek_scores)
        bottom_weekly = away_team_props['over_sixty'] += 1
        new_score = away_team_scores[gameweek.to_s] += 1
        away_team_props['over_sixty'] = bottom_weekly
        away_team_scores[gameweek.to_s] = new_score
        away_team.properties = away_team_props.to_json
        away_team.gameweek_scores = away_team_scores.to_json
        away_team.save!
      end
    end
  end

  def self.calculate_points(team, gameweek)
    players = team.current_players
    captain = team.current_captain

    players_points = players.map do |p|
      JSON.parse(p['gameweek_points'])[gameweek.to_s]
    end
    captain_points = JSON.parse(captain['gameweek_points'])[gameweek.to_s]

    players_points.sum + captain_points
  end
end
