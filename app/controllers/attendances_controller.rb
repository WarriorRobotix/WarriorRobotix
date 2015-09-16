class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]
  before_action :set_member, except: [:checkout_all, :checkin_group, :checkout_group]
  before_action :authenticate_admin!

  # GET members/1/attendances
  # GET members/1/attendances.json
  def index
    @attendances = @member.attendances.where.not(status: 0).all
  end

  # GET members/1/attendances/1
  # GET members/1/attendances/1.json
  def show
  end

  # GET members/1/attendances/new
  def new
    @attendance = Attendance.new
    @attendance.status = :attending
  end

  # GET members/1/attendances/1/edit
  def edit
  end

  def checkout_group
    checkout_array = params[:checkout_group_array]
    if !checkout_array.nil?
      current_date = Time.zone.now
      checkout_array.each do |f|
        member = Member.find(f)
        member.attendances.all.each do |i|
          checked_in = false
          checked_out = false
          if !i.start_at.nil? && i.start_at.year == current_date.year && i.start_at.month == current_date.month && i.start_at.day == current_date.day
            checked_in = true
            if !i.end_at.nil?
              checked_out = true
            end
          end
          if checked_in == true && checked_out == false
            i.update_attribute(:end_at, Time.zone.now)
            i.update_attribute(:status, :attended)
          end
        end
      end
    end
    flash[:notice] = "Selected Members Checked Out!"
    redirect_to attend_path
  end

  def checkin_group
    checkin_array = params[:checkin_group_array]

    if !checkin_array.nil?
      current_date = Time.zone.now
      @check = false
      checkin_array.each do |f|
        @checkedin_today = false
        member = Member.find(f)
        member.attendances.all.each do |i|
          if !i.start_at.nil? && i.status != :invited && i.event_id.nil?
            attendance_date = i.start_at.to_datetime
            current_date = Time.zone.now
            if attendance_date.day == current_date.day && attendance_date.month == current_date.month && attendance_date.year == current_date.year
              @checkedin_today = true
            end
          end
        end
        if @checkedin_today == false
          @check = true
          Attendance.create(:member_id => member.id, :start_at => Time.zone.now, :status => :attending)
        end
      end
      if @check == true
        flash[:notice] = "Selected Members Checked In!"
      else
        flash[:alert] = "Selected Members Already Checked In!"
      end
    end
    redirect_to attend_path
  end

  def checkout_all
    @checkedin = Array.new
    current_date = Time.zone.now
    Attendance.all.each do |f|
      if f.event_id.nil?
        attendance_date = f.start_at
        if !f.start_at.nil? && f.end_at.nil?
          if attendance_date.day == current_date.day && attendance_date.month == current_date.month && attendance_date.year == current_date.year
            @checkedin.push(f)
          end
        end
      end
    end
    if !@checkedin.empty?
      @checkedin.each do |f|
        f.update_attribute(:end_at, Time.zone.now)
        f.update_attribute(:status, :attended)
      end
      flash[:notice] = "Everyone is checked out!"
    end
    redirect_to :back
  end

  # POST members/1/attendances
  # POST members/1/attendances.json
  def create
    @attendance = Attendance.new(attendance_params)
    @attendance.member = @member


    start_at_date = params[:attendance][:start_at][:date]
    start_at_hour = params[:attendance][:start_at][:hour]
    start_at_minute = params[:attendance][:start_at][:minute]
    @attendance.start_at = Time.parse("#{params[:attendance][:start_at][:date]} @ #{params[:attendance][:start_at][:hour]}:#{params[:attendance][:start_at][:minute]}")

    end_at_date = params[:attendance][:end_at][:date]
    end_at_hour = params[:attendance][:end_at][:hour]
    end_at_minute = params[:attendance][:end_at][:minute]
    @attendance.end_at = Time.parse("#{params[:attendance][:end_at][:date]} @ #{params[:attendance][:end_at][:hour]}:#{params[:attendance][:end_at][:minute]}")

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
    @attendance.update_attributes(attendance_params)

    start_at_date = params[:attendance][:start_at][:date]
    start_at_hour = params[:attendance][:start_at][:hour]
    start_at_minute = params[:attendance][:start_at][:minute]
    @attendance.start_at = Time.parse("#{params[:attendance][:start_at][:date]} @ #{params[:attendance][:start_at][:hour]}:#{params[:attendance][:start_at][:minute]}")

    end_at_date = params[:attendance][:end_at][:date]
    end_at_hour = params[:attendance][:end_at][:hour]
    end_at_minute = params[:attendance][:end_at][:minute]
    @attendance.end_at = Time.parse("#{params[:attendance][:end_at][:date]} @ #{params[:attendance][:end_at][:hour]}:#{params[:attendance][:end_at][:minute]}")

    respond_to do |format|
      if @attendance.save
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
      a_params = params.require(:attendance).permit(:status, :duration)
    end
end
