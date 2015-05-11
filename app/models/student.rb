class Student < ActiveRecord::Base
  belongs_to :cohort
  has_many :blogs, dependent: :destroy
  has_many :posts, through: :blogs
  has_many :blog_assignments, dependent: :destroy
  has_many :schedules, through: :cohort
  
  validates :github_username, :presence => true, :uniqueness => true

  def self.find_or_create_from_auth_hash(auth)
    where(github_username: auth.info.nickname).first_or_initialize.tap do |user|
      user.github_username = auth.info.nickname
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.image = auth.info.image
      user.save
    end
  end

  def full_name_or_github_name
    if first_name && last_name
      first_name + " " + last_name
    else
      github_username
    end
  end

  def first_name_or_github_name
    first_name || github_username
  end

  def blog
    blogs.first
  end

  def blog_assignments_for_schedule(schedule)
    blog_assignments.where(schedule_id: schedule.id)
  end

  def completed_blog_assignments(schedule)
    blog_assignments_for_schedule(schedule).select { |b| b.completed? }
  end

  def percent_blog_assignments_completed(schedule)
    (completed_blog_assignments(schedule).count.to_f / blog_assignments.count) * 100
  end

  def next_valid_day(previous_day, days_array, frequency)
    index = days_array.index(previous_day)
    new_index = (index + frequency)
    days_array[new_index]
  end

  def assign_blogs(schedule, current_day_index)
    valid_days = schedule.weekdays_that_arent_holidays
    due_date = valid_days[current_day_index]
    date_index = valid_days.index(due_date)
    until valid_days[date_index] == nil
      schedule.blog_assignments.create(due_date: valid_days[date_index], student_id: id)
      date_index += schedule.frequency
    end
  end

  def blog_posts_written_since_last_assignment_date
    past_assignments = blog_assignments.where("due_date < ?", Date.today.to_date)
    last_assignment = past_assignments.order('due_date DESC').first
    entries = blog.posts_after_date(last_assignment.due_date)
  end

  def blog_posts_written_since_previous_assignment(date)
    if blog
      past_assignments = blog_assignments.where("due_date < ?", date)
      last_assignment = past_assignments.order('due_date DESC').first
      if last_assignment
        blog.posts_for_range(last_assignment.due_date, date)
      else
        blog.posts_on_or_before_date(date)
      end
    else
      []
    end
  end

  def remaining_blog_assignments
    blog_assignments.where("due_date > #{Date.today}")
  end

end
