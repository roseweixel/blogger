class SchedulesController < ApplicationController
  def show
    @schedule = Schedule.find(params[:id])
  end

  def new
    @cohort = Cohort.find(params[:cohort_id])
    @schedule = @cohort.schedules.build
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.cohort_id = (params[:cohort_id])
    @schedule.save
    
    redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
  end

  def generate_blog_rotation
    @schedule = Schedule.find(params[:id])
    @schedule.cohort.blog_assignments.all.destroy_all
    @schedule.generate_blog_assignments
    
    redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
  end

  private

    def schedule_params
      params.require(:schedule).permit(:name, :start_date, :end_date, :cohort_id, :frequency)
    end
end
