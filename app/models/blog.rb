class Blog < ActiveRecord::Base
  belongs_to :student
  delegate :cohort, to: :student

  validates :url, :presence => true, :uniqueness => true
  
  def feed_url
    Feedbag.find(url).first
  end

  def feed
    Feedjira::Feed.fetch_and_parse(feed_url)
  end

  def latest_entry
    feed.entries.first
  end

  def entries
    feed.entries
  end

  def entries_for_range(start_date, end_date)
    entries.select { |entry| entry.published > start_date && entry.published <= end_date }
  end

  def entries_after_date(date)
    entries.select { |entry| entry.published > date }
  end

  def entries_on_or_before_date(date)
    entries.select { |entry| entry.published <= date }
  end
end
