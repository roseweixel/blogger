class Blog < ActiveRecord::Base
  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :url, :presence => true, :uniqueness => true

  validate :url_is_valid
  validate :feed_url_is_valid

  after_create :set_title, :set_feed_url, :create_entries

  before_save :clean_url

  NULL_ATTRS = %w( feed_url )
  before_save :nil_if_blank

  def reset
    posts.clear
    set_feed_url
    set_title
  end

  def clean_url
    self.url = self.url.strip
  end

  def set_title
    self.update(title: feed.title) if feed != {}
  end

  def set_feed_url
    self.update(feed_url: Feedbag.find(url.strip).first)
  end

  def url_is_valid
    if !url.start_with?("http://") && !url.start_with?("https://")
      errors.add(:url, "You must enter the full blog url starting with http")
    end
  end

  def feed_url_is_valid
    if feed_url && !feed_url.empty? && !feed_url.start_with?("http://") && !feed_url.start_with?("https://")
      errors.add(:feed_url, "You must enter the full feed url starting with http")
    end
  end

  def full_url
    if !url.start_with?("http://") && !url.start_with?("https://")
      "http://" + url
    else
      url
    end
  end

  def create_entries
    entries.each do |entry|
      Post.where(url: entry.url).first_or_initialize.tap do |p|
        p.title = entry.title
        p.published_date = entry.published
        if entry.url.start_with?("/")
          p.url = (url + entry.url[1..-1])
        else
          p.url = entry.url
        end
        p.content = entry.content
        p.summary = entry.summary
        p.blog_id = id
        p.save
      end
    end
  end
  
  def url_for_feed
    feed_url || Feedbag.find(url.strip).first
  end

  def feed
    Feedjira::Feed.fetch_and_parse(url_for_feed)
  end

  def latest_entry
    feed.entries.first
  end

  def latest_post
    posts.order('published_date DESC').first
  end

  def entries
    feed.entries
  end

  def posts_for_range(start_date, end_date)
    posts.select { |post| post.published_date > start_date && post.published_date <= end_date }
  end

  def posts_after_date(date)
    posts.select { |post| post.published_date > date }
  end

  def posts_on_or_before_date(date)
    posts.select { |post| post.published_date <= date }
  end

  private

    def nil_if_blank
      NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
    end
end
