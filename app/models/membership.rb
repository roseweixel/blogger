class Membership < ActiveRecord::Base
  belongs_to :cohort
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :cohort_id
end
