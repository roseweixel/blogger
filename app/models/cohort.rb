require 'csv'
require 'open-uri'

class Cohort < ActiveRecord::Base
  has_many :students, dependent: :destroy
  has_many :blogs, through: :students
  
  has_attached_file :roster_csv
  validates_attachment_file_name :roster_csv, :matches => [/csv\Z/]

  validates :name, :presence => true, :uniqueness => true

  def create_students
    CSV.foreach(roster_csv.path).each_with_index do |row, index|
      if index == 0
        @student_attributes_array = row
      else
        student = students.new.tap do |s|
          @student_attributes_array.each_with_index do |attribute, index|
            s.send(attribute + '=', row[index])
          end
        end
        student.save
      end
    end
  end
end
