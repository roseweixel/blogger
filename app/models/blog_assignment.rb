class BlogAssignment < ActiveRecord::Base
  belongs_to :student
  belongs_to :schedule
end
