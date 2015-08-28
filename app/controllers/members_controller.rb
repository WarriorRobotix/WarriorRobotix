class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy, :reject, :approve]

  before_action :authenticate_admin!, except: [:index, :new, :create, :forgot, :send_reset_token, :reset_password_edit, :reset_password_update, :edit_email, :update_email, :edit_password, :update_password]
  before_action :authenticate_member!, only: [:index, :edit_email, :update_email, :edit_password, :update_password]

  # GET /members
  # GET /members.json
  def index
    @current_members = Member.where(graduated_year: nil).order(first_name: :ASC, last_name: :ASC).all.to_a
    if member_is_admin?
      @pending_members = Member.unscoped.where(accepted: false).all.to_a
      @graduated_members = Member.where.not(graduated_year: nil).order(graduated_year: :DESC).all.to_a
    end
  end

  def search
    @student_number = params[:text]
    @member = Member.find_by(:student_number => @student_number)
    #Check if user is already checked-in
    @checked = false
    @checkedin_today = false

    if !@member.nil?
    @member.attendances.each do |f|
      if !f.start_at.nil?
        attendance_date = f.start_at.to_datetime
        current_date = DateTime.now
        if attendance_date.day == current_date.day && attendance_date.month == current_date.month && attendance_date.year == current_date.year
          @checkedin_today = true
        end
        if f.end_at.nil? && @checkedin_today == true
          f.update_attribute(:end_at, DateTime.now)
          f.update_attribute(:status, :attended)
          @checked = true
          flash[:notice] = "You have been Checked Out"
        end
      end
    end
    if @checked == false
      if @checkedin_today == false
        @attendance = Attendance.create(:member_id => @member.id, :start_at => DateTime.now, :status => :attending)
        flash[:notice] = "You have been Checked In"
      else
        flash[:alert] = "You have already Checked In and Out Today!"
      end
    end
    redirect_to attend_path
    else
      redirect_to attend_path
      flash[:alert] = "Can not find anyone with that Student Number!"
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
      if @member.update(password: params[:password], password_confirmation: params[:password_confirmation], reset_password_at: nil, reset_password_digest: nil)
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
    @member.destroy
    MemberMailer.registration_rejected_email(@member).deliver_later
    respond_to do |format|
      format.html { redirect_to members_url, notice: "#{@member.full_name} was successfully rejected." }
    end
  end

  def forgot
  end

  def send_reset_token
    identifier = params[:identifier]
    if member = Member.where("(student_number = ? AND graduated_year IS NULL) OR email = ?", identifier, identifier).take
      token = member.generate_reset_password_token!
      MemberMailer.reset_password_email(member, token).deliver_now
    else
      flash[:alert] =  "Database doesn't have this student number"
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
      m_params = params[:member].permit(:first_name, :last_name, :email, :student_number, :grade, :title, :admin, :accepted, :graduated_year, :graduated, :password, :team)
      m_params[:graduated_year] = 0 unless (m_params.delete(:graduated).to_i == 1)
      m_params
    end
end
