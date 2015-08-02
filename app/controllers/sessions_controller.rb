class SessionsController < ApplicationController
  def new
  end

  def create
    identifier = params[:identifier]
    password = params[:password]
    if identifier.present? && password.present?
      if member = Member.where("(student_number = ? AND graduated_year IS NULL) OR email = ?", identifier, identifier).take.try(:authenticate, password)
        signin_member(member)
        if params[:from].present?
          redirect_to params[:from]
        else
          redirect_to root_path
        end
        return
      end
    end
    render :new
  end

  def destroy
    signout_member
    if params[:from].present?
      redirect_to params[:from]
    else
      redirect_to root_path
    end
  end
end
