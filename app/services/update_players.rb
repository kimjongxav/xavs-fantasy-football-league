class GetPlayerPoints
    def self.call
  
      resp = HTTParty.get('https://fantasy.premierleague.com/api/bootstrap-static/'); nil
      players = JSON.parse(resp.body)['elements']; nil
  
      players.all.each do |player|
        flonx_player = Player.where(id: player['id'])
        next unless flonx_player.empty?
  
        status = player['status']
        news = player['news']
        chance_of_playing = playing_chancer(status, news)
  
        flonx_player[:status] = status
        flonx_player[:news] = news
        flonx_player[:chance_of_playing] = chance_of_playing
  
        player.save!
      end
    end
  
    def playing_chancer(status, news)
      if status == "a"
        return "_100"
      elsif status == "i" || status =="u" || status == "s"
        return "_0"
      else 
        return "_" << news.gsub(/[^0-9]/, '')
      end
    end
  
  end