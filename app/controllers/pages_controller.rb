class PagesController < ApplicationController
  before_action :authenticate_admin!, only: [:attend]
  def home
    if member_signed_in?
      redirect_to posts_path
    end
  end
  def attend
    @keywords = params[:text]
    @like_groups = Member.find_by(:student_number => @keywords)

    if params[:json] == 'true'
      render json:[@like_groups]
    end
  end
end
