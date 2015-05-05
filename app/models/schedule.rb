class Schedule < ActiveRecord::Base
  belongs_to :cohort
  has_many :blog_assignments, through: :cohort
  
  HOLIDAYS = ['25/05/2015', '04/07/2015'].map { |date| Date.parse(date) }
  WEEKENDS = ['Saturday', 'Sunday']

  def generate_blog_assignments
    shuffled = cohort.students.shuffle
    counter = 0
    weekdays_that_arent_holidays.each do |day|
      students_per_day.times do
        BlogAssignment.create(student_id: shuffled[counter].id, due_date: day)
        counter < (shuffled.length - 1) ? counter += 1 : counter = 0
      end
    end
  end

  def posts_per_student
    days.count/frequency
  end

  def students_per_day
    (posts_per_student * cohort.students.count) / weekdays_that_arent_holidays.count
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
