class CalculateMatchScores
  def self.call
    gameweek = GetGameweek.call

    matches = Match.where(:gameweek => gameweek)

    matches.each do |match|
      home_team_score = 0
      away_team_score = 0

      home_team = match.home_team
      away_team = match.away_team

      home_team_points = calculate_points(home_team, gameweek)
      away_team_points = calculate_points(away_team, gameweek)

      home_team.gameweek_points[gameweek] = home_team_points
      home_team.gameweek_points_will_change!
      home_team.save!

      away_team.gameweek_points[gameweek] = away_team_points
      away_team.gameweek_points_will_change!
      away_team.save!

      puts "home team: #{home_team.id} (#{home_team_points})"
      puts "away team: #{away_team.id} (#{away_team_points})"

      if home_team_points == away_team_points
        home_team_score += 2
        away_team_score += 2

        home_team.properties[:draws] += 1
        home_team.properties_will_change!
        home_team.save!

        away_team.properties[:draws] += 1
        away_team.properties_will_change!
        away_team.save!
      elsif home_team_points > away_team_points
        home_team_score += 4
        away_team_score += 1 if (home_team_points - away_team_points) <= 5

        home_team.properties[:wins] += 1
        home_team.properties_will_change!
        home_team.save!

        away_team.properties[:losses] += 1
        away_team.properties[:matches_within_five_points] += 1 if (home_team_points - away_team_points) <= 5
        away_team.properties_will_change!
        away_team.save!
      elsif home_team_points < away_team_points
        away_team_score += 4
        home_team_score += 1 if (away_team_points - home_team_points) <= 5

        home_team.properties[:losses] += 1
        away_team.properties[:matches_within_five_points] += 1 if (away_team_points - home_team_points) <= 5
        home_team.properties_will_change!
        home_team.save!

        away_team.properties[:wins] += 1
        away_team.properties_will_change!
        away_team.save!
      end

      match.update!(
        :home_score => home_team_score,
        :away_score => away_team_score,
        :home_points => home_team_points,
        :away_points => away_team_points,
        :played => true,
      )

      home_team.gameweek_scores[gameweek] = home_team_score
      home_team.gameweek_scores_will_change!
      home_team.save!

      away_team.gameweek_scores[gameweek] = away_team_score
      away_team.gameweek_scores_will_change!
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

    most_points_teams = team_points.map { |k, v| k if v == team_points.values.max }.compact
    fewest_points_teams = team_points.map { |k, v| k if v == team_points.values.min }.compact
    over_sixty_teams = team_points.map { |k, v| k if v > 60 }.compact

    matches.each do |m|
      home_team = m.home_team
      away_team = m.away_team

      if most_points_teams.include?(m['home_team_id'])
        score = m['home_score']
        score += 1
        m.home_score = score
        m.save!

        home_team.properties[:top_weekly] += 1
        home_team.properties_will_change!
        home_team.save!

        home_team.gameweek_scores[gameweek] += 1
        home_team.gameweek_scores_will_change!
        home_team.save!
      end
      if most_points_teams.include?(m['away_team_id'])
        score = m['away_score']
        score += 1
        m.away_score = score
        m.save!

        away_team.properties[:top_weekly] += 1
        away_team.properties_will_change!
        away_team.save!

        away_team.gameweek_scores[gameweek] += 1
        away_team.gameweek_scores_will_change!
        away_team.save!
      end
      if fewest_points_teams.include?(m['home_team_id'])
        score = m['home_score']
        score -= 1
        m.home_score = score
        m.save!

        home_team.properties[:bottom_weekly] += 1
        home_team.properties_will_change!
        home_team.save!

        home_team.gameweek_scores[gameweek] -= 1
        home_team.gameweek_scores_will_change!
        home_team.save!
      end
      if fewest_points_teams.include?(m['away_team_id'])
        score = m['away_score']
        score -= 1
        m.away_score = score
        m.save!

        away_team.properties[:bottom_weekly] += 1
        away_team.properties_will_change!
        away_team.save!

        away_team.gameweek_scores[gameweek] -= 1
        away_team.gameweek_scores_will_change!
        away_team.save!
      end
      if over_sixty_teams.include?(m['home_team_id'])
        score = m['home_score']
        score += 1
        m.home_score = score
        m.save!

        home_team.properties[:over_sixty] += 1
        home_team.properties_will_change!
        home_team.save!

        home_team.gameweek_scores[gameweek] += 1
        home_team.gameweek_scores_will_change!
        home_team.save!
      end
      if over_sixty_teams.include?(m['away_team_id'])
        score = m['away_score']
        score += 1
        m.away_score = score
        m.save!

        away_team.properties[:over_sixty] += 1
        away_team.properties_will_change!
        away_team.save!

        away_team.gameweek_scores[gameweek] += 1
        away_team.gameweek_scores_will_change!
        away_team.save!
      end
    end
  end

  def self.calculate_points(team, gameweek)
    players = team.current_players
    captain = team.current_captain

    players_points = players.map do |p|
      p.gameweek_points[gameweek]
    end
    captain_points = captain.gameweek_points[gameweek]

    players_points.sum + captain_points
  end
end
