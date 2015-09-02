class ApplicationMailer < ActionMailer::Base
  before_action :attach_logo

  default :from => "no-reply@warrior-robotix.herokuapp.com"
  layout 'mailer'

  private
  def attach_logo
    attachments.inline['logo.png'] = File.read(Rails.root.join('app', 'assets', 'images', 'mailers', 'logo.png'))
  end
end
