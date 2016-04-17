class ScoutingEntriesController < ApplicationController
  before_action :set_scouting_entry, only: [:show, :edit, :update, :destroy]

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_admin!

  # GET /scouting_entries
  # GET /scouting_entries.json
  def index
    @scouting_entries = ScoutingEntry.all
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
      params.require(:scouting_entry).permit(:team_stat_id, :member_id, :extra_note, :rating, :drive_motors, :drive_motor_type, :drive_wheels, :drive_wheel_type, :drive_configuration, :drive_clearance, :shooter_type, :shooter_motors, :shooter_rpm, :intake_type, :intake_motors, :intake_motor_type, :intake_flip_capacity,
      :lift, :lift_motors, :lift_elevation, :lift_works, :driver_consistency, :driver_intelligence, :preloads_capacity, :shooter_consistency, :shooter_range, :autonomous_strategy, :autonomous_preload_points, :autonomous_field_points, :autonomous_reliability, :stalling, :connection_issues)
    end
end
