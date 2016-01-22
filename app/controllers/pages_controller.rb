class PagesController < ApplicationController
  skip_before_action :authenticate_admin!, only: [:home, :contact, :contact_message, :vex, :skills, :other_competitions, :website, :photos, :mentors, :about_us, :my_attendance, :member_contract]
  before_action :authenticate_member!, only: [:my_attendance]

  def home
    set_meta_tags_for_home if browser.bot?
    @show_side_buttons = true
    @latest_posts = Post.where(type: nil, restriction: 0).order(created_at: :DESC).limit(3).select(:id, :title, :description_stripdown)
  end

  def website
    set_meta_tags description: "At Warrior Robotix, we believe in doing everything by ourselves, that is why we built the website from ground up using Ruby On Rails, HTML, SASS, and Javascript. We applied modern web design principles to let the user get the best experience possible."
  end

  def vex
    set_meta_tags description: "VEX Skyrise was the latest challenge thrust upon us. The premise was fairly simple, putting cubes on to posts that dotted the edges of the arena. However, there were also yellow pegs called skyrises that could be stacked upon to create a 5 foot tall tower!"
  end

  def my_attendance
    @attendances = current_member.attendances.all.order(:start_at => :asc)
  end

  def skills
    set_meta_tags description: "Skills Robotics (Skills Canada) offers students a chance to push the boundaries of engineering by giving students a safe learning environment where they are taught to use machinery and their brains to solve the unique challenges thrown at them."
  end

  def other_competitions
    set_meta_tags description: "Warrior Robotic entered FRC for the first time in 2012-2013 year of school. The competitions at that time was Ultimate Ascent, where robots were tasked with throwing Frisbees at multiple goals and having to be able to climb a pyramid in the middle of the field."
  end

  def mentors
    set_meta_tags description: "Here at Warrior Robotix we pride ourselves by following our simple motto: Design. Build. Win. and for us it has worked effectively. We are based out of Port Credit Secondary School in Mississauga, Ontario, Canada, and have been competing in tournaments such as VEX and Skills Canada."
  end

  def about_us
  end

  def member_contract
    @page_title = "Member Contract"
  end

  def team_editor
    @teams = Team.all
    @members = Array.new
    Member.order(:first_name => :asc).each do |f|
      if f.team_id.nil?
        @members.push(f)
      end
    end
    @removemembers = Member.all
  end

  def contact
    @message = Hash.new
    @show_side_buttons = true
    @page_title = "Contact"
  end

  def contact_message
    @page_title = "Contact"
    @message = params.require(:message).permit(:full_name, :email, :phone_number, :body).to_h.symbolize_keys!
    if verify_recaptcha
      if @message[:full_name].blank?
        flash.now[:alert] = 'Please tell us your name.'
        @message[:full_name] = 'Anonymous'
      elsif @message[:body].blank?
        flash.now[:alert] = 'Message can\'t be blank.'
      else
        @message.merge!(ip: request.remote_ip.to_s, timestamp: Time.zone.now.to_s)
        ContactMailer.contact_us_email(@message).deliver_later
        flash[:notice] =  "Your message has successfully sent to us"
        redirect_to contact_path
        return
      end
    end
    render :contact
  end

  def attend
    @checkedin = Array.new
    @checkedout = Array.new
    current_date = Time.zone.now
    Attendance.order(member_id: :asc).each do |f|
      if f.event_id.nil?
        attendance_date = f.start_at
        if !f.start_at.nil? && f.end_at.nil?
          if attendance_date.day == current_date.day && attendance_date.month == current_date.month && attendance_date.year == current_date.year
            @checkedin.push(f)
          end
        end
        if !f.start_at.nil? && !f.end_at.nil?
          if attendance_date.day == current_date.day && attendance_date.month == current_date.month && attendance_date.year == current_date.year
            @checkedout.push(f)
          end
        end
      end
    end
    @event_today = false
    @event_list = Array.new
    Post.all.each do |f|
      if f.type == "Event"
        if f.start_at.day == current_date.day && f.start_at.month == current_date.month && f.start_at.year == current_date.year
          @event_today = true
          @event_list.push(f)
        end
      end
    end
  end

  def event
    @event = Event.find(params[:id])
    @checkedin = Array.new
    @checkedout = Array.new
    current_date = DateTime.now
    Attendance.order(start_at: :asc).each do |f|
      if !f.event_id.nil?
        attendance_date = f.start_at
        if !f.start_at.nil? && f.end_at.nil?
          if attendance_date.day == current_date.day && attendance_date.month == current_date.month && attendance_date.year == current_date.year
            @checkedin.push(f)
          end
        end
        if !f.start_at.nil? && !f.end_at.nil?
          if attendance_date.day == current_date.day && attendance_date.month == current_date.month && attendance_date.year == current_date.year
            @checkedout.push(f)
          end
        end
      end
    end
  end
  private
  def set_meta_tags_for_home
    set_meta_tags og: {
      title:    'Warrior Robotix',
      type:     'website',
      url:      'https://4659warriors.com',
      description: 'Team 4659 Warrior Robotix is the robotics club of Port Credit Secondary School in Mississauga. We participate in Vex, Skills Ontario and other robotics competitions.',
      image:    [{
        _: 'https://4659warriors.com/assets/pages/home/slider_image_0.jpg',
        type: 'image/jpeg',
        width: 1400,
        height: 700,
      },
      {
        _: 'https://4659warriors.com/assets/pages/home/slider_image_3.jpg',
        type: 'image/jpeg',
        width: 1400,
        height: 700,
      }]
    },  twitter: {
      site: '@WarriorRobotix',
      card: 'summary_large_image',
      description: 'Team 4659 Warrior Robotix is the robotics club of Port Credit Secondary School in Mississauga. We participate in Vex, Skills Ontario and other robotics competitions.',
      image: 'https://4659warriors.com/assets/pages/home/slider_image_0.jpg'
    }, canonical: 'https://4659warriors.com'
  end
end
