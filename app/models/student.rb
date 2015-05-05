class Student < ActiveRecord::Base
  belongs_to :cohort
  has_many :blogs, dependent: :destroy
  has_many :blog_assignments, dependent: :destroy
  
  validates :github_username, :presence => true, :uniqueness => true

  def full_name_or_github_name
    if first_name && last_name
      first_name + " " + last_name
    else
      github_username
    end
  end

  def blog
    blogs.first
  end

  def truncated_latest_entry_title
    blog.latest_entry.title[0..30] + '...'
  end

  def blog_entries_written_since_last_assignment_date
    past_assignments = blog_assignments.where("due_date < ?", Date.today.to_date)
    last_assignment = past_assignments.order('due_date DESC').first
    entries = blog.entries_after_date(last_assignment.due_date)
  end

end
