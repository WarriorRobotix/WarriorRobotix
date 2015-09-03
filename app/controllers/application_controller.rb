class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_action :authenticate_admin!

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
end
