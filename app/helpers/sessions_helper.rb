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
      @current_member = Member.find_by(:id => member_id)
      unless @current_member.nil?
        return @current_member
      else
        session[:member_id] = nil
      end
    elsif remember_cookies = cookies.signed[:mtk]
      member_id, token = remember_cookies.split("$")
      member_id = member_id.to_i
      if member = Member.find_and_authenticate_remember_token(member_id,token)
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

  def is_member_accepted?
    !current_member.nil? && current_member.accepted
  end

  alias_method :member_is_accepted?, :is_member_accepted?

  def signout_member
    cookies.delete :mtk
    session[:member_id] = @current_member = nil
  end

  def authenticate_member!
    unless member_signed_in?
      #flash[:notice] = "You need a display name to join groups."
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
