class Schedule < ActiveRecord::Base
  belongs_to :cohort
  
  HOLIDAYS = ['25/05/2015', '04/07/2015'].map { |date| Date.parse(date) }
  WEEKENDS = ['Saturday', 'Sunday']

  def generate_blog_assignments

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
