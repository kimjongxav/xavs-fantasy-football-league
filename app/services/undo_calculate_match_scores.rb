class UndoCalculateMatchScores
  def self.call(gameweek)
    matches = Match.where(:gameweek => gameweek)

    team_points = {}
    matches.each do |m|
      team_points[m['home_team_id']] = m['home_points']
      team_points[m['away_team_id']] = m['away_points']
    end

    @most_points_teams = team_points.map { |k, v| k if v == team_points.values.max }.compact
    @fewest_points_teams = team_points.map { |k, v| k if v == team_points.values.min }.compact
    @over_sixty_teams = team_points.map { |k, v| k if v > 60 }.compact

    matches.each do |m|
      reset_team_properties(m)
    end

    Team.all.each do |team|
      team.gameweek_scores.delete(gameweek)
      team.gameweek_points.delete(gameweek)
      team.save!
    end

    matches.each do |match|
      reset_match(match)      
    end
  end

  def self.reset_team_properties(m)
    home_team = m.home_team
    away_team = m.away_team

    if @most_points_teams.include?(m['home_team_id'])
      home_team.properties[:top_weekly] -= 1
      home_team.properties_will_change!
      home_team.save!
    end
    if @most_points_teams.include?(m['away_team_id'])
      away_team.properties[:top_weekly] -= 1
      away_team.properties_will_change!
      away_team.save!
    end
    if @fewest_points_teams.include?(m['home_team_id'])
      home_team.properties[:bottom_weekly] -= 1
      home_team.properties_will_change!
      home_team.save!
    end
    if @fewest_points_teams.include?(m['away_team_id'])
      away_team.properties[:bottom_weekly] -= 1
      away_team.properties_will_change!
      away_team.save!
    end
    if @over_sixty_teams.include?(m['home_team_id'])
      home_team.properties[:over_sixty] -= 1
      home_team.properties_will_change!
      home_team.save!
    end
    if @over_sixty_teams.include?(m['away_team_id'])
      away_team.properties[:over_sixty] -= 1
      away_team.properties_will_change!
      away_team.save!
    end
    if m.home_points == m.away_points
      home_team.properties[:draws] -= 1
      home_team.properties_will_change!
      home_team.save!

      away_team.properties[:draws] -= 1
      away_team.properties_will_change!
      away_team.save!
    elsif m.home_points > m.away_points
      home_team.properties[:wins] -= 1
      home_team.properties_will_change!
      home_team.save!

      away_team.properties[:losses] -= 1
      away_team.properties[:matches_within_five_points] -= 1 if (m.home_points - m.away_points) <= 5
      away_team.properties_will_change!
      away_team.save!
    elsif m.home_points < m.away_points
      home_team.properties[:losses] -= 1
      home_team.properties[:matches_within_five_points] -= 1 if (m.away_points - m.home_points) <= 5
      home_team.properties_will_change!
      home_team.save!

      away_team.properties[:wins] -= 1
      away_team.properties_will_change!
      away_team.save!
    end
  end

  def self.reset_match(match)
    match.home_score = 0
    match.away_score = 0
    match.home_points = 0
    match.away_points = 0
    match.played = false
    match.save!
  end
end
