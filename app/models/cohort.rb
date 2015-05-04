require 'csv'
require 'open-uri'

class Cohort < ActiveRecord::Base
  has_many :students
  has_many :blogs, through: :students
  has_attached_file :roster_csv
  validates_attachment_file_name :roster_csv, :matches => [/csv\Z/]

  # after_create :create_students

  # # errors out with
  # # Errno::ENOENT - No such file or directory @ rb_sysopen - /Users/rose/Development/code/flatiron-blog-app/public/system/cohorts/roster_csvs/000/000/009/original/students.csv
  # def create_students
  #   attributes_array = nil
  #   CSV.foreach(roster_csv.path).each_with_index do |row, index|
  #     if index == 0
  #       attributes_array = row
  #     else
  #       student = students.new.tap do |s|
  #         attributes_array.each_with_index do |attribute, index|
  #           s.send(attribute + '=', row[index])
  #         end
  #       end
  #       student.save
  #     end
  #   end
  # end

end
