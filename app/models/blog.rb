class Blog < ActiveRecord::Base
  def feed_url
    Feedbag.find(url).first
  end

  def feed
    Feedjira::Feed.fetch_and_parse(feed_url)
  end

  def most_recent_entry
    feed.entries.first
  end
end
