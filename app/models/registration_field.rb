class RegistrationField < ActiveRecord::Base
  enum input_type: [:text_field, :text_area, :select_tag]
  serialize :extra_info

  before_create :set_order
  before_destroy :correct_fields_order

  before_validation :try_map_to_member

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validate :select_tag_extra_info, if: :select_tag?
  validate :uniq_map_to

  def extra_info_for_human
    if input_type == "select_tag" && !extra_info.blank?
      if extra_info.length <= 1
        extra_info[0]
      else
        "#{extra_info[0...(-1)].join(',')} or #{extra_info[-1]}"
      end
    end
  end

  def self.input_type_for_select
    {
      "Text Field (Short Text or Number)" => :text_field,
      "Text Area (Long Paragraph)" => :text_area,
      "Select Tag (Single Choice Options)" => :select_tag
    }
  end

  def options
    if @options.present?
      @options
    elsif input_type == "select_tag"
      @options = extra_info.join("\n")
    else
      nil
    end
  end

  def options=(val)
    @options = val
    unless @options.nil?
      if input_type == "select_tag"
        self.extra_info = @options.lines.map(&:chomp)
      end
    end
  end

  def try_map_to_member
    return unless title_changed?
    title_underscore = title.to_s.downcase.parameterize.underscore
    if title_underscore == 'e_mail' #Force covert e-mail to email to ensure consistency
      self.title = 'Email'
      title_underscore = 'email'
    end
    if mappable_attribute =  Member.mappable_attributes[title_underscore]
      self.map_to = title_underscore
      self.input_type = mappable_attribute[:type]
      self.extra_info = mappable_attribute[:extra_info]
      unless mappable_attribute[:optional].nil?
        self.optional = mappable_attribute[:optional]
      end
    end
    true
  end

  def self.valid_member_fields?
    where(map_to: [:first_name, :last_name, :email, :grade]).count == 4
  end

  def input_value_valid?(value)
    if value.blank?
      self.optional
    elsif select_tag?
      self.extra_info.include?(value.to_s)
    else
      true
    end
  end

  private
  def set_order
    self.order = RegistrationField.all.count
  end

  def correct_fields_order
    RegistrationField.where("\"registration_fields\".\"order\" > #{self.order}").update_all("\"order\" = \"order\" - 1")
  end

  def select_tag_extra_info
    errors.add(:options, 'should have at least 2 lines') if (self.extra_info.nil? || self.extra_info.length < 2)
  end

  def uniq_map_to
    unless map_to.nil? || errors[:title].any? || !map_to_changed?
      flag = false
      if new_record?
        flag = RegistrationField.where(map_to: map_to).exists?
      else
        flag = RegistrationField.where(map_to: map_to).where.not(id: self.id).exists?
      end
      errors.add(:base, "Map to attribute value has already taken. This error may causes by similar title with another field") if flag
    end
  end
end
