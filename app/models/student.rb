class Student < ActiveRecord::Base
  belongs_to :cohort
  has_many :blogs, dependent: :destroy
  has_many :blog_assignments, dependent: :destroy
  
  validates :github_username, :presence => true, :uniqueness => true

  def blog
    blogs.first
  end

  def truncated_latest_entry_title
    blog.latest_entry.title[0..30] + '...'
  end

end
