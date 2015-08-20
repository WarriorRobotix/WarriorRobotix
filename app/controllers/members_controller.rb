class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_admin!, except: [:index, :new, :create]
  before_action :authenticate_member!, only: [:index]

  # GET /members
  # GET /members.json
  def index
    @current_members = Member.where(graduated_year: nil).order(first_name: :ASC, last_name: :ASC).all.to_a
    if member_is_admin?
      @pending_members = Member.where(accepted: false).all.to_a
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
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
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
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
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

  end

  def edit_password

  end

  def update_password

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:member_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      m_params = params[:member].permit(:first_name, :last_name, :email, :student_number, :grade, :title, :admin, :accepted, :graduated_year, :graduated, :password, :team)
      m_params[:graduated_year] = 0 unless (m_params.delete(:graduated).to_i == 1)
      m_params
    end
end
