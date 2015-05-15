class Blog < ActiveRecord::Base
  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :url, :presence => true, :uniqueness => true

  after_create :set_title, :create_entries

  def set_title
    self.update(title: feed.title)
  end

  def create_entries
    entries.each do |entry|
      posts.create.tap do |p|
        p.title = entry.title
        p.published_date = entry.published
        if entry.url.start_with?("/")
          p.url = (url + entry.url[1..-1])
        else
          p.url = entry.url
        end
        p.content = entry.content
        p.save
      end
    end
  end
  
  def feed_url
    Feedbag.find(url).first
  end

  def feed
    Feedjira::Feed.fetch_and_parse(feed_url)
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
end
