class SessionsController < ApplicationController
  skip_before_action :authenticate_admin!, only: [:new, :create, :destroy]
  skip_before_action :verify_authenticity_token

  def new
    redirect_back if member_signed_in?
  end

  def create
    identifier = params[:identifier]
    password = params[:password]
    respond_to do |format|
      flag = true
      if identifier.present? && password.present?
        if member = Member.where("(student_number = ? AND graduated_year IS NULL) OR email = ?", identifier, identifier).take.try(:authenticate, password)
          signin_member(member)
          cookies.permanent[:mtk] = "#{member.id}$#{member.remember_token}" if params[:remember_me] == '1'
          format.html { redirect_back notice: "You have successfully signed in" }
          format.json { render json: {access: member.max_restriction} }
          flag = false
        end
      end
      if flag
        flash.now[:alert] =  "Wrong email and password combination"
        format.html { render :new }
        format.json { render json: {access: 0} }
      end
    end
  end

  def destroy
    signout_member
    redirect_back
  end
end
