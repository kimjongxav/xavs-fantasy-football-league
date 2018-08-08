desc 'This task is called by the Heroku scheduler add-on'
task :get_player_points => :environment do
  puts 'getting player points'
  # runs at 2am
  GetPlayerPoints.call
end

task :calculate_match_scores => :environment do
  puts 'calculating match scores'
  # runs at 3am
  CalculateMatchScores.call
end
