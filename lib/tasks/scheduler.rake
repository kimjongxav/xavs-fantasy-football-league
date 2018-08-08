desc 'This task is called by the Heroku scheduler add-on'
task :get_player_points => :environment do
  puts 'getting player points'
  if Time.now.thursday?
    GetPlayerPoints.call
  end
end

task :calculate_match_scores => :environment do
  puts 'calculating match scores'
  if Time.now.thursday?
    CalculateMatchScores.call
  end
end

task :calculate_team_points => :environment do
  puts 'calculating team points'
  CalculateTeamPoints.call
end
