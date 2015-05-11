class BlogAssignment < ActiveRecord::Base
  belongs_to :student
  belongs_to :schedule

  def self.due_tomorrow
    where(due_date: Date.tomorrow)
  end
end
