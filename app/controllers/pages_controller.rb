class PagesController < ApplicationController
  before_action :authenticate_admin!, only: [:attend]
  def home
    if member_signed_in?
      redirect_to posts_path
    end
  end
  def attend

  end
end
