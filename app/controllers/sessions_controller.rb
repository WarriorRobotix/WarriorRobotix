class SessionsController < ApplicationController
  def new
  end

  def create
    identifier = params[:identifier]
    password = params[:password]
    if identifier.present? && password.present?
      if member = Member.where("(student_number = ? AND graduated_year IS NULL) OR email = ?", identifier, identifier).take.try(:authenticate, password)
        signin_member(member)
        redirect_back
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

  private
  def is_identifier_email?(identifier)
    (identifier =~ /.+@.+/).present?
  end
end
