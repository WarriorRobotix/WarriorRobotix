class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]
  before_action :set_member, except: [:checkout_all, :checkin_group, :checkout_group, :center, :check_in, :check_out, :set_check_in]
  before_action :authenticate_admin!

  # GET members/1/attendances
  # GET members/1/attendances.json
  def index
    @attendances = @member.attendances.where.not(status: 0).order(start_at: :ASC).all

    @total_hours = 0.0
    @attendances.each do |attendance|
      @total_hours += attendance.duration_float
    end
    @total_hours /= 3600.0

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
    @attendance.start_at = Time.zone.parse("#{params[:attendance][:start_at][:date]} @ #{params[:attendance][:start_at][:hour]}:#{params[:attendance][:start_at][:minute]}")

    end_at_date = params[:attendance][:end_at][:date]
    end_at_hour = params[:attendance][:end_at][:hour]
    end_at_minute = params[:attendance][:end_at][:minute]
    @attendance.end_at = Time.zone.parse("#{params[:attendance][:end_at][:date]} @ #{params[:attendance][:end_at][:hour]}:#{params[:attendance][:end_at][:minute]}")

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
    @attendance.start_at = Time.zone.parse("#{params[:attendance][:start_at][:date]} @ #{params[:attendance][:start_at][:hour]}:#{params[:attendance][:start_at][:minute]}")

    end_at_date = params[:attendance][:end_at][:date]
    end_at_hour = params[:attendance][:end_at][:hour]
    end_at_minute = params[:attendance][:end_at][:minute]
    @attendance.end_at = Time.zone.parse("#{params[:attendance][:end_at][:date]} @ #{params[:attendance][:end_at][:hour]}:#{params[:attendance][:end_at][:minute]}")

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to member_attendances_path(@member), notice: 'Attendance was successfully updated.' }
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

  def center
    members = Member.order(first_name: :ASC, last_name: :ASC).all.select(:id, :first_name, :last_name, :grade, :team_id)
    member_ids = Set.new( members.map { |m| m.id } )

    today = Time.zone.now
    today_attendances = Hash.new
    Attendance.where(start_at: today.beginning_of_day..today.end_of_day).order(created_at: :DESC).all.each do |attendance|
      today_attendances[attendance.member_id] = attendance
    end

    @teams = Team.order(name: :ASC).all
    team_names = Hash.new
    @teams.each do |team|
      team_names[team.id] = team.name
    end

    @unchecked_members = []
    @unchecked_member_teams = Hash.new {|h,k| h[k] = [] }

    @checked_in_attendance_descriptions = []
    @checked_out_attendance_descriptions = []

    members.each do |member|
      if today_attendances.include?(member.id)
        attendance = today_attendances[member.id]
        description = [member.id, member.full_name, team_names[member.team_id], attendance.start_at, attendance.end_at]
        if attendance.end_at.nil?
          @checked_in_attendance_descriptions << description
        else
          @checked_out_attendance_descriptions << description
        end
      else
        @unchecked_members << member
        @unchecked_member_teams[member.team_id] << member
      end
    end
  end

  def check_in
    time_now = Time.zone.now

    if params[:search] == '1'
      check_in_member = Member.where(student_number: params[:student_number]).take
      if check_in_member.nil?
        flash[:alert] = "Member #{params[:student_number]} can't be found"
        redirect_to attendances_center_path
        return
      else
        member_ids = [{ member_id: check_in_member.id, start_at: time_now, status: 1}]
      end
    else
      member_ids = Set.new( params[:members].keys.map { |e| e.to_i } )
      attended_today_ids = Set.new( Attendance.where(start_at: time_now.beginning_of_day..time_now.end_of_day).pluck(:id) )

      member_ids = member_ids - attended_today_ids

      member_ids = member_ids.to_a.map { |e| { member_id: e, start_at: time_now, status: 1} }
    end

    if Attendance.create(member_ids)
      flash[:notice] = "Selected Members Checked In!"
    else
      flash[:alert] = "There is a problem"
    end
    redirect_to attendances_center_path
  end

  def check_out
    time_now = Time.zone.now
    if params[:id] == 'all'
      attendances = Attendance.where(start_at: time_now.beginning_of_day..time_now.end_of_day, end_at: nil, status: 1).all
    else
      attendances = Attendance.where(start_at: time_now.beginning_of_day..time_now.end_of_day, end_at: nil, status: 1, member_id: params[:id].to_i).all
    end

    if params[:time].blank?
      check_out_time = time_now
    else
      check_out_time = Time.zone.parse(params[:time])
    end

    attendances.update_all(status: 2, end_at: check_out_time)
    redirect_to attendances_center_path
  end

  def set_check_in
    time_now = Time.zone.now
    Attendance.where(start_at: time_now.beginning_of_day..time_now.end_of_day, end_at: nil, status: 1).update_all(start_at: Time.zone.parse(params[:time]))
    redirect_to attendances_center_path
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
