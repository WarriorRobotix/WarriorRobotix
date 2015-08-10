class PagesController < ApplicationController
  before_action :authenticate_member!, only: [:test]
  def home
    if member_signed_in?
      redirect_to '/posts'
    end
  end
  def test
    render plain: "OK, #{current_member.first_name} #{current_member.last_name} LEVEL #{max_restriction}"
  end
end
