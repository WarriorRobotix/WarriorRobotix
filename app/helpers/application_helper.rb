module ApplicationHelper
  def return_to_info
    { from: request.fullpath == '/' ? nil : request.fullpath }
  end

  def white_spaces(n=1)
    raw( "&nbsp;" * n )
  end

  def markdown(text)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true, hard_wrap: true ), autolink: true, strikethrough: true, tables: true, underline: true)
    raw(@markdown.render(text))
  end
end
