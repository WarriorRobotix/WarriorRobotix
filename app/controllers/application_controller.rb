class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :authenticate_admin!
  before_action :set_basic_meta_tags, if: "request.get?"

  before_action do
    logger.info "CloudFlare Vistor: #{request.headers['Cf-Visitor']} IP:#{request.headers['X-Forwarded-For']} Country: #{request.headers['CF-Ipcountry']}"
  end

  before_action do
    if max_restriction == 3 && current_member.show_debug_profiler
      Rack::MiniProfiler.authorize_request
    end
  end

  def redirect_back(options={})
    if params[:from].present?
      redirect_to params[:from], options
    elsif block_given?
      yield
    else
      redirect_to root_path, options
    end
  end

  def parse_datetime_params(values)
    unless values.nil? || values[:date].blank? || values[:hour].blank? || values[:minute].blank?
      date = values[:date]
      hour = values[:hour]
      mintue = values[:minute]
      if hour =~ /\A\d\d?\Z/ && mintue =~ /\A\d\d?\Z/
        hour = hour.to_i
        minute = minute.to_i
        if hour.between?(0,24) && minute.between?(0,60)
          return Time.zone.parse(date).change(hour: hour, min: minute)
        end
      end
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
