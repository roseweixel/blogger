class Schedule < ActiveRecord::Base
  belongs_to :cohort
  has_many :blog_assignments, dependent: :destroy
  has_many :users, through: :cohort

  accepts_nested_attributes_for :blog_assignments
  
  HOLIDAYS = ['25/05/2015', '04/07/2015'].map { |date| Date.parse(date) }
  WEEKENDS = ['Saturday', 'Sunday']

  # guarantees that there will be a consistent number of blog assignments on each day, frequency will be approximately what was specified
  def generate_blog_assignments_based_on_students_per_day
    shuffled = cohort.users.shuffle
    counter = 0
    weekdays_that_arent_holidays.each do |day|
      students_per_day.times do
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
    shuffled.each_with_index do |student, index|
      if index != 0 && index % students_per_day == 0
        current_day_index += 1
      end
      student.assign_blogs(self, current_day_index)
    end
  end

  def posts_per_student
    weekdays_that_arent_holidays.count / frequency
  end

  def students_per_day
    (posts_per_student * cohort.users.count) / weekdays_that_arent_holidays.count
  end

  def leftover_posts
    (posts_per_student * cohort.users.count) % weekdays_that_arent_holidays.count
  end

  def days
    (start_date..end_date).to_a
  end

  def weekdays
    days.select { |day| !WEEKENDS.include?(day.strftime("%A")) }
  end

  def weekdays_that_arent_holidays
    weekdays - HOLIDAYS
  end
end
