class BlogAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :schedule
  belongs_to :post
  validates_uniqueness_of :due_date, :scope => [:user, :schedule]
  validates_uniqueness_of :post, allow_blank: true

  NULL_ATTRS = %w( post_id )
  before_save :nil_if_blank

  def self.due_tomorrow
    where(due_date: Date.tomorrow)
  end

  def completed?
    user.blog_posts_written_since_previous_assignment(due_date, schedule).find { |post| post.content_or_summary.length > 140 } || post
  end

  def posts_since_previous
    posts = user.blog_posts_written_since_previous_assignment(due_date, schedule)
    if posts.empty?
      post ? [post] : posts
    else
      posts
    end
  end

  def most_recent_post_since_previous
    posts_since_previous.first
  end

  private

    def nil_if_blank
      NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
    end
end
