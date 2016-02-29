class MarkdownRender
  require 'redcarpet/render_strip'
  class << self
    def render(text)
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: false, hard_wrap: true ), autolink: true, strikethrough: true, tables: true, underline: true)
      @markdown.render(text)
    end

    def stripdown(text)
      @stripdown_render ||= Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
      @stripdown_render.render(text)
    end
  end
end
