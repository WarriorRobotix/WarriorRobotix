class Poll < Post
  enum ballots_privacy: [:voters_viewable, :counts_viewable]
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true
  validate :immutable_active_poll_attributes
  validate :min_restriction

  after_initialize do
    self.restriction = 1 if self.restriction = 0
  end

  def option_descriptions
    @option_descriptions ||= self.options.all.pluck(:description).tap {|x| x << nil if x.empty?}
  end

  def ballots_from(member)
    unless member.nil?
      Ballot.joins(:option).where(member_id: member.id, options: { poll_id: self.id }).pluck(:option_id)
    else
      []
    end
  end

  def active?
    options.any? {|option| (option.ballots_count || 0) > 0}
  end

  def self.valid_restrictions
    restrictions.except("everyone")
  end

  private
  def immutable_active_poll_attributes
    errors.add(:multiple_choices, 'attribute can\'t change on an active poll') if multiple_choices_changed? && active?
  end

  def min_restriction
    errors.add(:restriction, 'should higher than viewable to everyone') if restriction == "everyone"
  end
end
