class HolidaysController < ApplicationController
  def create
    holidays = params[:holidays].split(", ").map{|date| Date.strptime(date, "%m/%d/%Y")}
    Holiday.set_holidays(holidays)
    redirect_to :back
  end

  def set_default_holidays
    Holiday.set_holidays_to_default
    redirect_to :back
  end
end
