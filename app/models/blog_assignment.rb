class BlogAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :schedule

  def self.due_tomorrow
    where(due_date: Date.tomorrow)
  end

  def completed?
    user.blog_posts_written_since_previous_assignment(due_date).any?
  end

  def posts_since_previous
    user.blog_posts_written_since_previous_assignment(due_date)
  end

  def most_recent_post_since_previous
    posts_since_previous.first
  end
end
