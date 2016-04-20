class ScoutingEntriesController < ApplicationController
  before_action :set_scouting_entry, only: [:show, :edit, :update, :destroy]

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_admin!

  # GET /scouting_entries
  # GET /scouting_entries.json
  def index
    @fetched_at = Time.zone.now.to_s
    @scouting_entries = ScoutingEntry.includes(:team_stat).all

    if params[:after].present?
      after = Time.zone.parse(params[:after])
      if after.present?
        @scouting_entries = @scouting_entries.where("updated_at > ?", after)
      end
    end
  end

  # GET /scouting_entries/1
  # GET /scouting_entries/1.json
  def show
  end

  # GET /scouting_entries/new
  def new
    @scouting_entry = ScoutingEntry.new
  end

  # GET /scouting_entries/1/edit
  def edit
  end

  # POST /scouting_entries
  # POST /scouting_entries.json
  def create
    @scouting_entry = ScoutingEntry.new(scouting_entry_params)
    @scouting_entry.member_id = current_member&.id || 67

    if params[:team_stat_number].present? && !params[:team_stat_id].present?
      @scouting_entry.team_stat = TeamStat.where(number: params[:team_stat_number]).take
    end

    respond_to do |format|
      if @scouting_entry.save
        format.html { redirect_to @scouting_entry, notice: 'Scouting entry was successfully created.' }
        format.json { render :show, status: :created, location: @scouting_entry }
      else
        format.html { render :new }
        format.json { render json: @scouting_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST-JSON /scouting_entries/mass.json
  def mass
    scouting_entries = params["scouting_entries"]
    success = true
    number_of_success = 0
    number_of_failure = 0

    scouting_entries.each do |entry|
      member_id = current_member&.id || 67

      if entry.key? "team_stat_id"
        team_stat_id = entry["team_stat_id"]
      elsif entry.key? "team_stat_number"
        team_stat_id = TeamStat.where(number: entry["team_stat_number"]).take&.id
      end

      unless team_stat_id.present?
        number_of_failure += 1
        logger.error "ScoutingEntry Error params:#{entry} errors:Invalid or empty team_stat_id/team_stat_number"
        success = false
        next
      end

      acceptable_attribute_set = Set.new(acceptable_attributes) - Set.new([:team_stat_id, :member_id])
      entry.keep_if { |k,v| acceptable_attribute_set.include? k.to_sym }

      scouting_entry = ScoutingEntry.find_or_create_by(team_stat_id: team_stat_id, member_id: member_id)
      scouting_entry.attributes = entry.symbolize_keys

      if scouting_entry.save
        number_of_success += 1
      else
        number_of_failure += 1
        logger.error "ScoutingEntry Error params:#{entry} errors:#{scouting_entry.errors.full_messages.join(' ')}"
        success = false
      end
    end

    respond_to do |format|
      format.all { render json: {success: success, number_of_success:number_of_success, number_of_failure: number_of_failure} }
    end
  end

  # PATCH/PUT /scouting_entries/1
  # PATCH/PUT /scouting_entries/1.json
  def update
    respond_to do |format|
      if @scouting_entry.update(scouting_entry_params)
        format.html { redirect_to @scouting_entry, notice: 'Scouting entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @scouting_entry }
      else
        format.html { render :edit }
        format.json { render json: @scouting_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scouting_entries/1
  # DELETE /scouting_entries/1.json
  def destroy
    @scouting_entry.destroy
    respond_to do |format|
      format.html { redirect_to scouting_entries_url, notice: 'Scouting entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scouting_entry
      @scouting_entry = ScoutingEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scouting_entry_params
      params.require(:scouting_entry).permit(acceptable_attributes)
    end

    def acceptable_attributes
      [:team_stat_id, :member_id, :extra_note, :rating, :drive_motors, :drive_motor_type, :drive_wheels, :drive_wheel_type, :drive_configuration, :drive_clearance, :shooter_type, :shooter_motors, :shooter_rpm, :intake_type, :intake_motors, :intake_motor_type, :intake_flip_capacity,
      :lift, :lift_motors, :lift_elevation, :lift_works, :driver_consistency, :driver_intelligence, :preloads_capacity, :shooter_consistency, :shooter_range, :autonomous_strategy, :autonomous_preload_points, :autonomous_field_points, :autonomous_reliability, :stalling, :connection_issues]
    end
end
