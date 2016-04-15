class FetchMatchesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    # Do something later
    TeamStat.create(number: '4659A')
  end
end
