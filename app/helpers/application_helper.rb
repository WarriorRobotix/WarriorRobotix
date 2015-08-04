module ApplicationHelper
  def return_to_info
    { from: request.fullpath == '/' ? nil : request.fullpath }
  end

  def white_spaces(n=1)
    raw( "&nbsp;" * n )
  end
end
