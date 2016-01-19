module ApplicationHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context
  include ActionView::Helpers::TextHelper
  include ReturnToHelper

  def errors_for(object, message = nil)
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
          if message.nil?
            title << " prohibited this #{object.model_name.human.downcase} from being "
            title << (object.new_record? ? 'created' : 'saved')
          else
            title << " #{message}"
          end
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
    raw(MarkdownRender.render(text))
  end

  def markdown_complex(text)
    m_text = MarkdownRender.render(text)
    processed_text = []
    while img_index = m_text.index("<img")
      processed_text << m_text.slice!(0..img_index)

      src_index = m_text.index(" src=\"")
      processed_text[-1] += m_text.slice!(0...(src_index + 6))

      src_end_index = m_text.index("\"")
      processed_text << (">img:#{m_text.slice!(0...src_end_index)}")
    end
    processed_text << m_text
    processed_text
  end

  def hash_modal(prefix, url_format, options={})
    options = options.merge(class: 'hash-modal', id: "hm-#{prefix}", remote: true)
    link_to prefix, url_format, options
  end

  def try_short_format_duration(start_date, end_date, max_length = 25)
    return if start_date.nil? || end_date.nil?

    string =  "#{start_date.strftime('%B %d, %Y')} - #{end_date.strftime('%B %d, %Y')}"
    return string if string.length <= max_length

    start_date_str = (start_date.strftime('%B').length <= 5) ? '%B %d, %Y' : '%b %d, %Y'

    end_date_str = (end_date.strftime('%B').length <= 5) ? '%B %d, %Y' : '%b %d, %Y'

    string =  "#{start_date.strftime(start_date_str)} - #{end_date.strftime(end_date_str)}"
    return string if string.length <= max_length

    "#{start_date.strftime('%b %d, %Y')} - #{end_date.strftime('%b %d, %Y')}"
  end
end
