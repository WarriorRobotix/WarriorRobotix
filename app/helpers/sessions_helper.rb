module SessionsHelper
  include ReturnToHelper
  def signin_member(member)
    session[:member_id] = member.id
    @current_member = member
  end

  def current_member
    if !@current_member.nil?
      return @current_member
    elsif member_id = session[:member_id]
      @current_member = Rails.cache.fetch("member/id/#{member_id}", :expires_in => 5.minutes) do
        Member.find_by(:id => member_id)
      end
      unless @current_member.nil?
        return @current_member
      else
        session[:member_id] = nil
      end
    elsif remember_cookies = cookies[:mtk]
      member_id, token = remember_cookies.split("$")
      member_id = member_id.to_i
      if member = Member.find_and_authenticate_remember_token(member_id,token)
        flash.now[:notice] = 'You have signed in via remember me'
        return signin_member(member)
      else
        cookies.delete :mtk
      end
    end
    nil
  end

  def member_signed_in?
    !current_member.nil?
  end

  def is_member_admin?
    !current_member.nil? && current_member.admin
  end

  alias_method :member_is_admin?, :is_member_admin?

  def signout_member
    session[:member_id] = @current_member = nil
  end

  def authenticate_member!
    unless member_signed_in?
      redirect_to signin_path(return_to_info)
      return false
    end
    true
  end

  def authenticate_admin!
    if authenticate_member!
      raise Forbidden  unless member_is_admin?
    end
  end

  def max_restriction
    current_member.try(:max_restriction) || 0
  end
end
