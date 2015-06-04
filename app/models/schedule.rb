class Schedule < ActiveRecord::Base
  belongs_to :cohort
  has_many :blog_assignments, dependent: :destroy
  has_many :users, through: :cohort

  validate :end_date_is_after_start_date
  validates :name, length: { maximum: 50 }

  accepts_nested_attributes_for :blog_assignments

  WEEKEND_DAYS = ['Saturday', 'Sunday']

  def end_date_is_after_start_date
    errors.add(:end_date, "must be after start date") if end_date <= start_date
  end

  # guarantees that there will be a consistent number of blog assignments on each day, frequency will be approximately what was specified
  def generate_blog_assignments_based_on_users_per_day
    shuffled = cohort.users.shuffle
    counter = 0
    weekdays_that_arent_holidays.each do |day|
      bloggers_per_day.times do
        blog_assignments.create(user_id: shuffled[counter].id, due_date: day)
        counter < (shuffled.length - 1) ? counter += 1 : counter = 0
      end
    end
  end

  # guarantees specified frequency will be adhered to, side effect is sometimes days get skipped or have inconsistent number of students per day
  def generate_blog_assignments
    shuffled = cohort.users.shuffle
    current_day_index = 0
    max_day = weekdays_that_arent_holidays.last
    shuffled.each_with_index do |user, index|
      if index != 0 && index % bloggers_per_day == 0
        current_day_index += 1
      end
      user.assign_blogs(self, current_day_index)
    end
  end

  def posts_per_blogger
    (weekdays_that_arent_holidays.count / frequency)
  end

  def bloggers_per_day
    ((posts_per_blogger * cohort.users.count) / weekdays_that_arent_holidays.count) + 1
  end

  def leftover_posts
    (posts_per_blogger * cohort.users.count) % weekdays_that_arent_holidays.count
  end

  def days
    (start_date..end_date).to_a
  end

  def weekdays
    days.select { |day| !WEEKEND_DAYS.include?(day.strftime("%A")) }
  end

  def weekdays_that_arent_holidays
    weekdays - Holiday.all.pluck(:date)
  end
end
