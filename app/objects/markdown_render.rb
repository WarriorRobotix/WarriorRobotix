class MarkdownRender
  class << self
    def render(text)
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true, hard_wrap: true ), autolink: true, strikethrough: true, tables: true, underline: true)
      @markdown.render(text)
    end
  end
end
