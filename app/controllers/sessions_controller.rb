class SessionsController < ApplicationController
  def new
    redirect_back if member_signed_in?
  end

  def create
    identifier = params[:identifier]
    password = params[:password]
    if identifier.present? && password.present?
      if member = Member.where("(student_number = ? AND graduated_year IS NULL) OR email = ?", identifier, identifier).take.try(:authenticate, password)
        signin_member(member)
        redirect_back notice: "You have successfully signed in"
        return
      end
    end
    flash[:alert] =  "Wrong email and password combination"
    render :new
  end

  def destroy
    signout_member
    redirect_back
  end
end
