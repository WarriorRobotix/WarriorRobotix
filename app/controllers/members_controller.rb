class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_member!, except: [:index]

  # GET /members
  # GET /members.json
  def index
    @member_groups = [["Current Members", []], ["Pending Members", Member.where(accepted: false).to_a]]
    accepted_members = Member.where(accepted: true).order(year_of_graduation: :DESC, full_name: :ASC)
    year = nil
    accepted_members.each do |member|
      if member.year_of_graduation.nil?
        @member_groups[0][1] << member
      else
        if year != member.year_of_graduation
          year = member.year_of_graduation
          @member_groups << [year.to_s,[]]
        end
        @member_groups[-1][1] << member
      end
    end
  end

  # GET /members/1
  # GET /members/1.json
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
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      m_params = params[:member].permit(:full_name, :email, :student_number, :grade, :title, :admin, :accepted, :year_of_graduation, :graduated)
      m_params[:year_of_graduation] = 0 unless (m_params.delete(:graduated).to_i == 1)
      m_params
    end
end
