class PagesController < ApplicationController
  before_action :authenticate_member!, only: [:test]
  def home
  end
  def test
    render plain: "OK"
  end
end
