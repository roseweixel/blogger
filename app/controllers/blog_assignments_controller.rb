class BlogAssignmentsController < ApplicationController
  def new
    @schedule = Schedule.find(params[:schedule_id])
  end

  def create
    binding.pry
  end
end
