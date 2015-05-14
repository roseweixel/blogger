require 'csv'

class Cohort < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :blogs, through: :users
  has_many :blog_assignments, through: :users
  has_many :schedules, dependent: :destroy
  
  has_attached_file :roster_csv
  validates_attachment_file_name :roster_csv, :matches => [/csv\Z/]
  
  validates :name, :presence => true, :uniqueness => true
  
  after_save :create_members

  def create_members
    return if !roster_csv.path
    
    memberships.clear
    
    csv_array = CSV.foreach(roster_csv.path)
    @github_username_index = csv_array.first.index('github_username')
    
    csv_array.each_with_index do |row, index|
      if index == 0
        @member_attributes_array = row
      else
        create_or_update_user_from_csv(row)
        Membership.create(user_id: @member.id, cohort_id: id)
      end
    end
  end

  def create_or_update_user_from_csv(row)
    @member = User.where(github_username: row[@github_username_index]).first_or_initialize.tap do |user|
      @member_attributes_array.compact.each_with_index do |attribute, index|
        user.send(attribute + '=', row[index])
      end
      user.save
    end
  end

end
