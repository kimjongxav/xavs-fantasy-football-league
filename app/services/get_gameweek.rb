class GetGameweek
  def self.call
    Gameweek.where("deadline_time_epoch < ?", DateTime.now.to_i).order(:deadline_time_epoch).last[:gameweek]
  end
end
