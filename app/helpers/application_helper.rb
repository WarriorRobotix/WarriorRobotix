module ApplicationHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context
  include ActionView::Helpers::TextHelper
  include ReturnToHelper

  def errors_for(object)
    return unless object.errors.any?
    content_tag :div, class:'card-panel error-explanation' do
      concat(content_tag(:div, class: 'panel-heading') do
        content_tag(:div, class: 'panel-title') do
          title = 'There'
          if object.errors.count == 1
            title << " is #{object.errors.count} error"
          else
            title << " are #{object.errors.count} errors"
          end
          title << " prohibited this #{object.model_name.human.downcase} from being "
          title << (object.new_record? ? 'created' : 'saved')
        end
      end)

      concat(content_tag(:div, class: 'panel-content') do
        content_tag(:table, class: 'bordered except-last') do
          object.errors.full_messages.each do |msg|
            concat(raw('<tr><td>' + msg + '</td></tr>'))
          end
        end
      end)
    end
  end

  def flash_toasts
    "#{flash.map{|k,v| toast_for_flash(k,v)}.join(';')};" if flash.any?
  end

  def toast_for_flash(name,msg)
    case name
    when 'notice'
      css_class = 'toast-notice'
    when 'alert', 'recaptcha_error'
      css_class = 'toast-alert'
    else
      css_class = 'toast-base'
    end
    "Materialize.toast('#{j msg}', '4000', '#{css_class}')"
  end


  def white_spaces(n=1)
    raw( "&nbsp;" * n )
  end

  def markdown(text)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true, hard_wrap: true ), autolink: true, strikethrough: true, tables: true, underline: true)
    raw(@markdown.render(text))
  end

  def hash_modal(prefix, url_format, options={})
    options = options.merge(class: 'hash-modal', id: "hm-#{prefix}", remote: true)
    link_to prefix, url_format, options
  end
end
