class Holiday < ActiveRecord::Base
  validates :date, presence: true, uniqueness: true

  def self.set_holidays_to_default
    next_year_of_holidays = Holidays.between(Date.today, Date.today + 365, :us, :observed)
    dates = next_year_of_holidays.map{|holiday| holiday[:date]}
    self.set_holidays(dates)
  end

  def self.set_holidays(date_array)
    Holiday.all.destroy_all
    date_array.each do |date|
      Holiday.create(date: date)
    end
  end
end
