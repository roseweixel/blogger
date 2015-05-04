require 'csv'
require 'open-uri'

class Cohort < ActiveRecord::Base
  has_many :students, dependent: :destroy
  has_many :blogs, through: :students
  
  has_attached_file :roster_csv
  validates_attachment_file_name :roster_csv, :matches => [/csv\Z/]

  validates :name, :presence => true, :uniqueness => true
end
