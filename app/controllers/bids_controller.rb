class BidsController < TeamsController
  before_action do
    @team = Team.find(params[:team_id])
  end

  def new
    @available_formations = available_formations
    @bid = Bid.new
  end

  def index
    @bids = Bid.paginate(:page => params[:page])
    @summer_rounds = @team.bids.where(:window => 'summer').map(&:round).uniq
    @january_rounds = @team.bids.where(:window => 'january').map(&:round).uniq
  end

  def create
    Bid.create!(
      :value => params[:bid][:value],
      :player_id => params[:bid][:player_id],
      :team_id => @team.id,
      :window => 'summer',
      :round => 1,
    )
    redirect_to :bids
  end

  def round
    
  end

  def available_formations
    %w[3-4-3 3-5-2 4-5-1 4-4-2 4-3-3 5-4-1 5-3-2]
  end
end
