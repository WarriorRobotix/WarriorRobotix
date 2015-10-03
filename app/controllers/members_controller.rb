class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :approve]

  skip_before_action :authenticate_admin!, only: [:index, :forgot, :send_reset_token, :reset_password_edit, :reset_password_update, :edit_email, :update_email, :edit_password, :update_password, :search]

  before_action :authenticate_member!, only: [:index, :edit_email, :update_email, :edit_password, :update_password]

  # GET /members
  # GET /members.json
  def index
    @current_members = Member.where(graduated_year: nil).order(team_id: :ASC,first_name: :ASC, last_name: :ASC).all
    if member_is_admin?
      @pending_members = Member.unscoped.where(accepted: false).all
      @graduated_members = Member.where.not(graduated_year: nil).order(graduated_year: :DESC, first_name: :ASC, last_name: :ASC).all
    end
  end

  def eventsearch
    @student_number = params[:text]
    @member = Member.find_by(:student_number => @student_number)
    @event = Event.find(params[:id])
    @event_attendance_created = false
    @status = ""
    if !@member.nil?
      @member.attendances.each do |f|
        if !f.event_id.nil? && f.event_id == @event.id
          @event_attendance_created = true
          @event_attendance = f
        end
      end
      if @event_attendance_created == true
        if !@event_attendance.start_at.nil?
          if !@event_attendance.end_at.nil?
            #already signed in and out
            flash[:alert] = "Already Checked In and Out!"
          else
            #need to check out
            @event_attendance.update_attribute(:end_at, Time.zone.now)
            @event_attendance.update_attribute(:status, :attended)
            flash[:notice] = "Successfully Checked Out!"
          end
        else
          #need to check in
          @event_attendance.update_attribute(:start_at, Time.zone.now)
          @event_attendance.update_attribute(:status, :attending)
          flash[:notice] = "Successfully Checked In!"
        end
      else
        #need to create a new attendance and check in
        Attendance.create(:member_id => @member.id, :event_id => @event.id, :start_at => Time.zone.now, :status => :attending)
        flash[:notice] = "Successfully Checked In!"
      end
      redirect_to :back
    else
      #student number invalid
      redirect_to :back
      flash[:alert] = "Can not find anyone with that Student Number!"
    end
  end

  def search
    @student_number = params[:text]
    @member = Member.find_by(:student_number => @student_number)
    #Check if user is already checked-in
    @checked = false
    @checkedin_today = false
    success = false
    
    allow_checkin = true
    allow_checkout = true
    
    if params[:check] == 'in'
      allow_checkout = false
    elsif params[:check] == 'out'
      allow_checkin = false
    end
    
    if is_member_admin?
      is_from_admin = true
    elsif member_signed_in?
      is_from_admin = false
    else
      if admin = Member.find_by(admin: true, student_number: params[:identifier]).try(:authenticate, params[:password])
        is_from_admin = true
      else
        is_from_admin = false
      end
    end
    
    if !@member.nil? && is_from_admin
      @member.attendances.each do |f|
        if !f.start_at.nil? && f.status != :invited && f.event_id.nil?
          attendance_date = f.start_at.to_datetime
          current_date = Time.zone.now
          if attendance_date.day == current_date.day && attendance_date.month == current_date.month && attendance_date.year == current_date.year
            @checkedin_today = true
          end
          if f.end_at.nil? && @checkedin_today == true && allow_checkout == true
            f.update_attribute(:end_at, Time.zone.now)
            f.update_attribute(:status, :attended)
            @checked = true
            success = true
            flash[:notice] = "#{@member.full_name} has been checked out..."
          end
        end
      end
      if @checked == false && allow_checkin == true
        if @checkedin_today == false
          @attendance = Attendance.create(:member_id => @member.id, :start_at => Time.zone.now, :status => :attending)
          success = true
          flash[:notice] = "#{@member.full_name} has been checked in..."
        else
          flash[:alert] = "#{@member.full_name} has already checked in and out today!"
        end
      end
    else
      flash[:alert] = "Can not find anyone with that Student Number!"
    end
    respond_to do |format|
      format.html { redirect_to attend_path }
      format.json { render json: {success: success} }
    end
  end

  # GET /members/1
  # GET /members/1.json
  # GET /members/1.js
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to members_path, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to members_path, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_email

  end

  def update_email
    respond_to do |format|
      if current_member.update(params.require(:member).permit(:email))
        format.html { redirect_to members_path, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: current_member }
      else
        format.html { render :edit_email }
        format.json { render json: current_member.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_password

  end

  def update_password
    password_params = params.require(:member).permit(:old_password, :password, :password_confirmation)
    respond_to do |format|
      (current_member.incorrect_old_password = true) unless (current_member.authenticate(params[:old_password]) == false)
      if current_member.update(password_params)
        format.html { redirect_to members_path, notice: 'Password was successfully updated.' }
        format.json { render :show, status: :ok, location: current_member }
      else
        format.html { render :edit_password }
        format.json { render json: current_member.errors, status: :unprocessable_entity }
      end
    end
  end

  def reset_password_edit
    @member = Member.find_by(id: params[:record_hex].to_i(16))
    unless @member.present? && @member.valid_reset_password_token?(params[:reset_token])
      render :invalid_reset_token
    end
  end

  def reset_password_update
    @member = Member.find_by(id: params[:record_hex].to_i(16))
    if @member.present? && @member.valid_reset_password_token?(params[:reset_token])
      @member.password_allow_nil = false
      @member.reset_password_at = nil
      @member.reset_password_digest = nil
      if @member.update(password: params[:password], password_confirmation: params[:password_confirmation])
        redirect_to signin_path
      else
        render :reset_password_edit
      end
    else
      render :invalid_reset_token
    end
  end

  def approve
    @member.accepted = true
    token = @member.generate_reset_password_token!
    MemberMailer.welcome_email(@member, token).deliver_later
    respond_to do |format|
      format.html { redirect_to members_url, notice: "#{@member.full_name} was successfully became a member." }
    end
  end

  def reject
    reason = params[:reason].blank? ? nil :  params[:reason]
    GlobalVar[:last_reject_members_reason] = reason
    @quite_reject = params[:commit] == "Quite Reject"
    if params[:member] == 'all'
      pending_members = Member.unscoped.where(accepted: false)
      unless @quite_reject
        pending_members.pluck(:first_name, :last_name, :email).map { |e| ["#{e[0]} #{e[1]}", e[2]] }.each do |pm|
          MemberMailer.registration_rejected_email(pm[0], pm[1], reason).deliver_later
        end
      end
      pending_members.destroy_all
    else
      if pending_member = Member.unscoped.where(id: params[:member].to_i, accepted: false).take
        pending_member.destroy
        MemberMailer.registration_rejected_email(pending_member.full_name, pending_member.email, reason).deliver_later unless @quite_reject
      end
    end

    respond_to do |format|
      if params[:member] == 'all'
        format.html { redirect_to members_url, notice: "All pending members were successfully#{" and quietly" if @quite_reject} rejected." }
      else
        format.html { redirect_to members_url, notice: "#{pending_member.try(:full_name) || 'A pending member'} was successfully#{" and quietly" if @quite_reject} rejected." }
      end
    end
  end

  def forgot
  end

  def send_reset_token
    identifier = params[:identifier]
    if member = Member.where("(student_number = ? AND graduated_year IS NULL) OR email = ?", identifier, identifier).take
      unless member.reset_password_at.nil? || (Time.zone.now - member.reset_password_at) > 5.minutes
        flash.now[:alert] =  "Can't send another reset password token within 5 minutes"
        render :forgot
      else
        token = member.generate_reset_password_token!
        MemberMailer.reset_password_email(member, token).deliver_later
      end
    else
      flash.now[:alert] =  "Database doesn't have this student number"
      render :forgot
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.unscoped.find(params[:member_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      m_params = params[:member].permit(:first_name, :last_name, :email, :student_number, :grade, :title, :admin, :accepted, :graduated_year, :graduated, :team_id)
      m_params[:graduated_year] = 0 unless (m_params.delete(:graduated).to_i == 1)
      m_params
    end
end
