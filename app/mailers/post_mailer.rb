class PostMailer < ApplicationMailer
  default from: 'Warrior Robotix <notification@4659warriors.com>'

  def post_email(post, new_post)
    @post = post
    @new_post = new_post
    @title = new_post ? @post.title : "Update: #{@post.title}"
    mail(subject: @title, bcc: mail_list)
  end

  def event_email(event, new_event)
    @event = event
    @new_event = new_event
    @title = new_event ? @event.title : "Update: #{@event.title}"
    mail(subject: @title, bcc: mail_list)
  end

  def poll_email(poll, new_poll)
    @poll = poll
    @new_poll = new_poll
    @title = new_poll ? @poll.title : "Update: #{@poll.title}"
    mail(subject: @title, bcc: mail_list)
  end

  private
  def mail_list
    post = @post || @event || @poll
    if post.everyone? || post.member?
      Member.all.pluck(:email)
    elsif post.admin?
      Member.where(admin: true).all.pluck(:email)
    else
      []
    end
  end
end
