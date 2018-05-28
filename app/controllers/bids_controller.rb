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
    @rounds = @team.bids.group_by { |h| [h[:round], h[:window]] }.map(&:second)
  end

  def create
    Bid.create!(
      :value => params[:bid][:value],
      :player_id => params[:bid][:player_id],
      :team_id => @team.id,
      :window => 'summer',
      :round => 1,
    )
    redirect_to :team_bids
  end

  def available_formations
    [
      ['Select a formation', 0],
      ['3-4-3', 1],
      ['3-5-2', 2],
      ['4-5-1', 3],
      ['4-4-2', 4],
      ['4-3-3', 5],
      ['5-4-1', 6],
      ['5-3-2', 7],
    ]
  end

  def position_calculator(i, formation_id)
    return 'GK' if i.zero?
    formation = available_formations[formation_id].first
    position_counts = formation.split('-')
    defs = position_counts[0].to_i
    mids = position_counts[1].to_i

    return 'DEF' if i <= defs
    return 'MID' if i <= (defs + mids)
    'FWD'
  end
end
