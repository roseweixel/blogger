class Cohort < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :blogs, through: :users
  has_many :blog_assignments, through: :users
  has_many :schedules, dependent: :destroy
  has_many :holidays, through: :schedules
  
  has_attached_file :roster_csv
  validates_attachment_file_name :roster_csv, :matches => [/csv\Z/]
  
  validates :name, :presence => true, :uniqueness => true, length: { maximum: 50 }
  
  after_save :create_members, :if => :has_roster_csv_path?

  def create_members    
    memberships.clear
    CohortMaker.new(self, :github_username)
  end

  def has_roster_csv_path?
    !!roster_csv.path
  end
end
