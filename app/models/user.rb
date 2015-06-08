class User < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :cohorts, through: :memberships
  has_many :blogs, dependent: :destroy
  has_many :posts, through: :blogs
  has_many :blog_assignments, dependent: :destroy
  has_many :schedules, through: :cohorts
  
  validates :github_username, :presence => true, :uniqueness => true, length: { maximum: 50 }
  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :email, length: { maximum: 50 }

  def self.find_or_create_from_auth_hash(auth)
    binding.pry
    where(github_username: auth.info.nickname).first_or_initialize.tap do |user|
      user.access_token = auth.credentials.token
      user.github_username = auth.info.nickname
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.image = auth.info.image
      user.admin = user.is_admin?
      user.save
    end
  end

  def is_authorized?
    client.organization_member?('flatiron-school', github_username) || client.organization_member?('learn-co-students', github_username) || client.organization_member?('learn-co-curriculum', github_username)
  end

  def is_admin?
    client.organization_member?('learn-co-curriculum', github_username)
  end

  def name
    if first_name && last_name
      first_name + " " + last_name
    end
  end

  def client
    Octokit::Client.new(access_token: access_token, client_id: ENV['github_client_id'], client_secret: ENV['github_client_secret'])
  end

  def full_name_or_github_name
    name || github_username
  end

  def first_name_or_github_name
    first_name || github_username
  end

  # TODO: figure out how to handle which blog is the user's 'default' blog (or just allow users to have one blog)
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
    (completed_blog_assignments(schedule).count.to_f / blog_assignments_for_schedule(schedule).count) * 100
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
      schedule.blog_assignments.create(due_date: valid_days[date_index], user_id: id)
      date_index += schedule.frequency
    end
  end

  def blog_posts_written_since_last_assignment_date
    past_assignments = blog_assignments.where("due_date < ?", Date.today.to_date)
    last_assignment = past_assignments.order('due_date DESC').first
    entries = blog.posts_after_date(last_assignment.due_date)
  end

  def blog_posts_written_since_previous_assignment(date, schedule)
    if blog
      past_assignments = blog_assignments_for_schedule(schedule).where("due_date < ?", date)
      last_assignment = past_assignments.order('due_date DESC').first
      last_assignment ? blog.posts_for_range(last_assignment.due_date + 12.hours, date) : blog.posts_for_range(schedule.start_date - 7.days, date) 
    else
      []
    end
  end

  def remaining_blog_assignments
    blog_assignments.where("due_date > #{Date.today}")
  end

end
