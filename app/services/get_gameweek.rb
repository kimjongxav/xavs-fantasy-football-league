class GetGameweek
  def self.call
    url = 'https://fantasy.premierleague.com/drf/bootstrap-static'
    response = HTTParty.get(url)
    1 unless response
    body = JSON.parse(response.body)
    gameweek = body['current-event'] if response.ok?
    finished = body['events'].select { |e| e['id'] == 1 }.first['finished']
    return gameweek + 1 if finished
    gameweek
  end
end