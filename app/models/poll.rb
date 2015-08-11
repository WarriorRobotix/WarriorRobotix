class Poll < Post
  enum ballots_privacy: [:voters_viewable, :counts_viewable]
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true
  validate :immutable_active_poll_attributes

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

  private
  def immutable_active_poll_attributes
    if active?
      [:multiple_choices].each do |immu_attr|
        errors.add(immu_attr, 'attribute can\'t change on an active poll') if send("#{immu_attr}_changed?")
      end
    end
  end
end
