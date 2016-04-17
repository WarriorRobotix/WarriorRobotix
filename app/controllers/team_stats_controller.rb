class TeamStatsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :set_team_stat, only: [:show, :edit, :update, :destroy]

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_admin!

  # GET /team_stats
  # GET /team_stats.json
  def index
    @fetched_at = Time.zone.now
    @team_stats = TeamStat.includes(:division)

    if params[:team_numbers] == ""
      @team_stats = TeamStat.includes(:division).none
    elsif params[:team_numbers].present?
      after = Time.zone.parse(params[:after] || "")
      if after.present?
        @team_stats = @team_stats.where("( updated_at > ? ) OR ( number IN (?) )", after, ( params[:team_numbers] || "" ).split(".") )
      else
        @team_stats = @team_stats.where(number: (params[:team_numbers] || "" ).split(".") )
      end
    elsif params[:number].present?
      @team_stats = @team_stats.where(number: params[:number])
    elsif params[:division_id].present?
      @team_stats = @team_stats.where(division_id: params[:division_id])
    elsif params[:like].present?
      @team_stats = @team_stats.where("\"team_stats\".\"number\" LIKE ?", "%#{params[:like]}%")
    end

    @team_stats = @team_stats.order(sort_column + " " + sort_direction).all

  end

  # GET /team_stats/1
  # GET /team_stats/1.json
  def show
  end

  # GET /team_stats/new
  def new
    @team_stat = TeamStat.new
  end

  # GET /team_stats/1/edit
  def edit
  end

  # POST /team_stats
  # POST /team_stats.json
  def create
    @team_stat = TeamStat.new(team_stat_params)

    respond_to do |format|
      if @team_stat.save
        format.html { redirect_to @team_stat, notice: 'Team stat was successfully created.' }
        format.json { render :show, status: :created, location: @team_stat }
      else
        format.html { render :new }
        format.json { render json: @team_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_stats/1
  # PATCH/PUT /team_stats/1.json
  def update
    respond_to do |format|
      if @team_stat.update(team_stat_params)
        format.html { redirect_to @team_stat, notice: 'Team stat was successfully updated.' }
        format.json { render :show, status: :ok, location: @team_stat }
      else
        format.html { render :edit }
        format.json { render json: @team_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_stats/1
  # DELETE /team_stats/1.json
  def destroy
    @team_stat.destroy
    respond_to do |format|
      format.html { redirect_to team_stats_url, notice: 'Team stat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team_stat
      @team_stat = TeamStat.includes(:division).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_stat_params
      params.require(:team_stat).permit(:number, :team_name, :robot_score, :robot_rank, :programming_score, :programming_rank, :country, :city, :region, :division_id)
    end

    def sort_column
      TeamStat.column_names.include?(params[:sort]) ? params[:sort] : "actual_order"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
