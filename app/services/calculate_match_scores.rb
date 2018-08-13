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

      if home_team_points == away_team_points
        home_team_score += 2
        away_team_score += 2

        home_team.properties['draws'] = home_team.properties['draws'] + 1
        home_team.properties_will_change!
        home_team.save

        away_team.properties['draws'] = away_team.properties['draws'] + 1
        away_team.properties_will_change!
        away_team.save
      elsif home_team_points > away_team_points
        home_team_score += 4
        away_team_score += 1 if (home_team_points - away_team_points) <= 5

        home_team.properties['wins'] = home_team.properties['wins'] + 1
        home_team.properties_will_change!
        home_team.save

        away_team.properties['losses'] = away_team.properties['losses'] + 1
        away_team.properties_will_change!
        away_team.save
      elsif home_team_points < away_team_points
        away_team_score += 4
        home_team_score += 1 if (away_team_points - home_team_points) <= 5

        home_team.properties['losses'] = home_team.properties['losses'] + 1
        home_team.properties_will_change!
        home_team.save

        away_team.properties['wins'] = away_team.properties['wins'] + 1
        away_team.properties_will_change!
        away_team.save
      end

      match.update!(
        :home_score => home_team_score,
        :away_score => away_team_score,
        :home_points => home_team_points,
        :away_points => away_team_points,
        :played => true,
      )
    end

    update_scores(gameweek)
  end

  def self.update_scores
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
        match.update!(:home_score => score)

        home_team.properties['top_weekly'] = home_team.properties['top_weekly'] + 1
        home_team.properties_will_change!
        home_team.save
      end
      if most_points_teams.include?(m['away_team_id'])
        score = m['away_score']
        score += 1
        match.update!(:away_score => score)

        away_team.properties['top_weekly'] = away_team.properties['top_weekly'] + 1
        away_team.properties_will_change!
        away_team.save
      end
      if fewest_points_teams.include?(m['home_team_id'])
        score = m['home_score']
        score -= 1
        match.update!(:home_score => score)

        home_team.properties['bottom_weekly'] = home_team.properties['bottom_weekly'] + 1
        home_team.properties_will_change!
        home_team.save
      end
      if fewest_points_teams.include?(m['away_team_id'])
        score = m['away_score']
        score -= 1
        match.update!(:away_score => score)

        away_team.properties['bottom_weekly'] = away_team.properties['bottom_weekly'] + 1
        away_team.properties_will_change!
        away_team.save
      end
      if over_sixty_teams.include?(m['home_team_id'])
        score = m['home_score']
        score += 1
        match.update!(:home_score => score)

        home_team.properties['over_sixty'] = home_team.properties['over_sixty'] + 1
        home_team.properties_will_change!
        home_team.save
      end
      if over_sixty_teams.include?(m['away_team_id'])
        score = m['away_score']
        score += 1
        match.update!(:away_score => score)

        away_team.properties['over_sixty'] = away_team.properties['over_sixty'] + 1
        away_team.properties_will_change!
        away_team.save
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
