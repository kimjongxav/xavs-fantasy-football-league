class BidsController < TeamsController
  def new; end

  def index
    @bids = Bid.paginate(:page => params[:page])
    @team = Team.find(params[:team_id])
  end
end
