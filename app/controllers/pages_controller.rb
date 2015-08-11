class PagesController < ApplicationController
  def home
    if member_signed_in?
      redirect_to posts_path
    end
  end
end
