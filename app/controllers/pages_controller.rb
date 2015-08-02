class PagesController < ApplicationController
  before_action :authenticate_member!, only: [:test]
  def home
  end
  def test
    render plain: "OK, #{current_member.first_name} #{current_member.last_name}"
  end
end
