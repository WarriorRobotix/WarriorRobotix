class Poll < Post
  enum ballots_privacy: [:voters_viewable, :counts_viewable]
  has_many :options
  accepts_nested_attributes_for :options, allow_destroy: true

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
end
