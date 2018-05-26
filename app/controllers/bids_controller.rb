class BidsController < TeamsController
  def new
    @available_formations = available_formations
    @bid = Bid.new
  end

  def index
    @bids = Bid.paginate(:page => params[:page])
    @team = Team.find(params[:team_id])
  end

  def available_formations
    %w[3-4-3 3-5-2 4-5-1 4-4-2 4-3-3 5-4-1 5-3-2]
  end
end
