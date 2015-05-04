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
end
