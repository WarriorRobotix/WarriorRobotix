# Preview all emails at http://localhost:3000/rails/mailers/post_mailer
class PostMailerPreview < ActionMailer::Preview
  def post_email
    PostMailer.post_email(Post.where(type: nil).take!,true)
  end

  def updated_post_email
    PostMailer.post_email(Post.where(type: nil).take!,false)
  end

  def event_email
    PostMailer.event_email(Event.take!,true)
  end

  def poll_email
    PostMailer.poll_email(Poll.take!,true)
  end
end
