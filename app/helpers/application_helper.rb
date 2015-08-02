module ApplicationHelper
  def return_to_info
    { from: request.fullpath == '/' ? nil : request.fullpath }
  end
end
