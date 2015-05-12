require 'csv'
require 'open-uri'

class Cohort < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships
  has_many :blogs, through: :users
  has_many :blog_assignments, through: :users
  has_many :schedules
  
  has_attached_file :roster_csv
  validates_attachment_file_name :roster_csv, :matches => [/csv\Z/]

  validates :name, :presence => true, :uniqueness => true
  after_save :create_students

  def create_members
    return if !roster_csv.path
    memberships.clear
    parsed_csv = CSV.foreach(roster_csv.path)
    github_username_index = parsed_csv.first.index('github_username')
    CSV.foreach(roster_csv.path).each_with_index do |row, index|
      if index == 0
        @member_attributes_array = row
      else
        member = User.find_by(github_username: row[github_username_index])
        if !member 
          member = User.new.tap do |s|
            @member_attributes_array.compact.each_with_index do |attribute, index|
              s.send(attribute + '=', row[index])
            end
          end
        end
        Membership.create(user_id: member.id, cohort_id: id)
        member.save
      end
    end
  end
end
