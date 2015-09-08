class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :authenticate_admin!
  before_action :set_basic_meta_tags, if: "request.get?"

  def redirect_back(options={})
    if params[:from].present?
      redirect_to params[:from], options
    elsif block_given?
      yield
    else
      redirect_to root_path, options
    end
  end

  alias_method :try_redirect_back, :redirect_back
  private
  def set_basic_meta_tags
    set_meta_tags description: "Team 4659 Warrior Robotix is the robotics club of Port Credit Secondary School in Mississauga. We participate in Vex, Skills Ontario and other robotics competitions."
    set_meta_tags keywords: ["warrior robotix", "vex", "vrc", "4659", "robot", "robotics", "club", "port credit secondary school", "mississauga"]
    set_meta_tags icon: '/favicon.ico'

    set_meta_tags "msapplication-TileColor" => "#ffffff", "msapplication-TileImage" => "icons/ms-icon-144x144.png"

    set_meta_tags fb: {app_id: '843857822394784'}
  end
end
