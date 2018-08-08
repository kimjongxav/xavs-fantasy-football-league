desc 'This task is called by the Heroku scheduler add-on'
task :get_player_points => :environment do
  if Time.now.thursday?
    GetPlayerPoints.call
  end
end

task :calculate_match_scores => :environment do
  if Time.now.thursday?
    CalculateMatchScores.call
  end
end
