class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]
  before_action :set_member

  # GET members/1/attendances
  # GET members/1/attendances.json
  def index
    @attendances = @member.attendances.all
  end

  # GET members/1/attendances/1
  # GET members/1/attendances/1.json
  def show
  end

  # GET members/1/attendances/new
  def new
    @attendance = Attendance.new
    @attendance.status = :attended
  end

  # GET members/1/attendances/1/edit
  def edit
  end

  # POST members/1/attendances
  # POST members/1/attendances.json
  def create
    @attendance = Attendance.new(attendance_params)
    @attendance.member = @member


    respond_to do |format|
      if @attendance.save
        format.html { redirect_to [@member, @attendance], notice: 'Attendance was successfully created.' }
        format.json { render :show, status: :created, location: @attendance }
      else
        format.html { render :new }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT members/1/attendances/1
  # PATCH/PUT members/1/attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to [@member, @attendance], notice: 'Attendance was successfully updated.' }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE members/1/attendances/1
  # DELETE members/1/attendances/1.json
  def destroy
    @attendance.destroy
    respond_to do |format|
      format.html { redirect_to member_attendances_url(@member), notice: 'Attendance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    def set_member
      @member = Member.find(params[:member_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendance_params
      a_params = params.require(:attendance).permit(:start_at, :end_at, :status, :skip_end_at)
    end
end
