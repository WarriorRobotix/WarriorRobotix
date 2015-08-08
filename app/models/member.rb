class Member < ActiveRecord::Base
  has_secure_password
  before_validation :set_default_password, on: :create

  before_validation :set_invalid_graduated_year_to_nil, :titleize_names

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :grade, presence: true

  validates :email, presence: true, uniqueness: true, format: { with: /.+@.+/, message: "format is invalid" }

  validates :student_number, allow_blank: true, format: { without: /.+@.+/, message: "format is invalid" }

  has_many :attendances
  has_many :posts

  def reset_password
    self.reset_password_at = Time.zone.now

    reset_password_token = SecureRandom.hex

    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    self.reset_password_digest = BCrypt::Password.create(reset_password_token, cost: cost)

    reset_password_token
  end

  def valid_reset_password_token?(token)
    self.reset_password_digest.present? && self.reset_password_at.present? && ((Time.zone.now - self.reset_password_at) < 2.days) && BCrypt::Password.new(self.reset_password_digest).is_password?(token)
  end

  def regenerate_remember_token
    remember_token = SecureRandom.urlsafe_base64
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    self.remember_digest = BCrypt::Password.create(remember_token, cost: cost)
    remember_token
  end

  def self.find_and_authenticate_remember_token(record_id, remember_token)
    member = Member.where(id: record_id).take
    unless member.nil?
      member if member.authenticate_remember_token?(remember_token)
    end
  end

  def authenticate_remember_token?(token)
    self.remember_digest.nil? ? false : BCrypt::Password.new(self.remember_digest).is_password?(token)
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.create_admin
    admin = Member.new(admin: true, accepted: true)
    puts "Create an admin..."
    puts "First Name:"
    admin.first_name = gets.chomp
    puts "Last Name:"
    admin.last_name = gets.chomp
    puts "Email:"
    admin.email = gets.chomp
    puts "Grade:"
    admin.grade = gets.chomp
    puts "Student Number:"
    admin.student_number = gets.chomp
    admin.student_number = nil if admin.student_number.blank?
    puts "Password:"
    admin.password = gets.chomp

    if admin.save
      puts "Admin #{admin.full_name} has successfully created"
      admin
    else
      puts "#{admin.errors.count} #{admin.errors.count == 1 ? "error" : "errors"} prohibited this admin account from being saved:"
      admin.errors.full_messages.each {|msg| puts msg}
      admin
    end
  end

  def max_restriction
    admin ? 2 : 1
  end

  private
  def set_default_password
    self.password ||= SecureRandom.base64(40)
  end

  def set_invalid_graduated_year_to_nil
    self.graduated_year = nil if !self.graduated_year.nil? && (self.graduated_year < 1900)
  end

  def titleize_names
    self.first_name.capitalize!
    self.last_name.capitalize!
  end
end
