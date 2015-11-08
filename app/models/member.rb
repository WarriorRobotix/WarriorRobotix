class Member < ActiveRecord::Base
  has_secure_password

  validates :password, length: { in: 5..64 }, unless: :password_nil?

  serialize :extra_info
  before_validation :set_default_password, on: :create
  before_validation :set_invalid_graduated_year_to_nil, :titleize_names, :remove_trailing_space

  validates :first_name, presence: true, format: { with: /\A[A-Z]([a-zA-Z\-\s\.]+[a-zA-Z\.]|[a-zA-Z\.]?)\z/, message: "format is invalid. It must starts with a uppercase letter, following uppercase letters(A-Z), lowercase letters(a-z), hyphens(-), spaces, or dots(.). It can't end with hyphen and space" }
  validates :last_name, presence: true, format: { with: /\A[A-Z]([a-zA-Z\-\s\.]+[a-zA-Z\.]|[a-zA-Z\.]?)\z/, message: "format is invalid. It must starts with a uppercase letter, following uppercase letters(A-Z), lowercase letters(a-z), hyphens(-), spaces, or dots(.). It can't end with hyphen and space" }

  validates :grade, presence: true

  validates :email, presence: true, uniqueness: true, format: { with: /\A.+@.+\.[^\.]+\z/, message: "format is invalid" }

  validates :student_number, presence: true, uniqueness: true, numericality: { only_integer: true }

  validate :extra_info_fields
  validate :admin_must_accpeted
  validate :correct_old_password
  validate :ensure_password_not_nil

  has_many :attendances, dependent: :destroy
  has_many :ballots, dependent: :destroy
  has_many :posts

  default_scope { where(accepted: true) }

  attr_accessor :reset_password_token
  attr_accessor :old_password
  attr_accessor :incorrect_old_password
  attr_accessor :password_allow_nil

  def generate_reset_password_token!
    self.reset_password_at = Time.zone.now

    self.reset_password_token = SecureRandom.urlsafe_base64(6)

    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    self.reset_password_digest = BCrypt::Password.create(self.reset_password_token, cost: cost)
    self.save!

    self.reset_password_token
  end

  def valid_reset_password_token?(token)
    self.reset_password_digest.present? && self.reset_password_at.present? && ((Time.zone.now - self.reset_password_at) < 2.days) && BCrypt::Password.new(self.reset_password_digest).is_password?(token)
  end

  def remember_token
    if self.remember_digest.nil?
      self.remember_digest = SecureRandom.urlsafe_base64
      self.save
    end
    self.remember_digest
  end

  def self.find_and_authenticate_remember_token(record_id, remember_token)
    member = Member.where(id: record_id).take
    unless member.nil?
      member if member.remember_digest == remember_token
    end
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
    admin ? 3 : 1
  end

  def self.mappable_attributes
    @mappable_attributes ||= {
      "first_name" => { :type => :text_field, :optional => false },
      "last_name" => { :type => :text_field, :optional => false },
      "email" => { :type => :text_field, :optional => false },
      "student_number" => { :type => :text_field, :optional => false },
      "grade" => { :type => :select_tag, :extra_info => ('9'..'12').to_a, :optional => false }
    }
  end

  def extra_info
    super || {}
  end

  def add_extra_info_field_error(err)
    (@extra_info_field_errors ||= []) << err
  end

  def member_type
    if admin
      "Admin"
    elsif accepted
      "Member"
    else
      "Pending Member"
    end
  end

  def abbr_name
    "#{self.first_name} #{self.last_name[0]}."
  end

  private
  def password_nil?
    self.password.nil?
  end

  def remove_trailing_space
    self.first_name = self.first_name.rstrip
    self.last_name = self.last_name.rstrip
  end

  def correct_old_password
    if self.incorrect_old_password
      errors.add(:old_password, 'is incorrect')
    end
  end

  def set_default_password
    self.password ||= SecureRandom.base64(40)
  end

  def set_invalid_graduated_year_to_nil
    self.graduated_year = nil if !self.graduated_year.nil? && (self.graduated_year < 1900)
  end

  def titleize_names
    unless self.first_name.blank? || !(self.first_name[0] =~ /[[:lower:]]/)
      self.first_name = self.first_name[0].upcase + self.first_name[1..(-1)]
    end
    unless self.last_name.blank? || !(self.last_name[0] =~ /[[:lower:]]/)
      self.last_name = self.last_name[0].upcase + self.last_name[1..(-1)]
    end
  end

  def extra_info_fields
    errors[:base].concat(@extra_info_field_errors) unless @extra_info_field_errors.blank?
  end

  def admin_must_accpeted
    errors.add(:accepted, 'must be true for an admin account') if (admin && !accepted)
  end

  def ensure_password_not_nil
    errors.add(:password, :blank) if !(password_allow_nil.nil? || password_allow_nil) && password.nil?
  end
end
