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
    
    # @schedule.students.each do |student|
    #   StudentMailer.initial_schedule_notification(@schedule, student).deliver_now
    # end

    redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
  end

  def edit
    @schedule = Schedule.find(params[:id])
    @cohort = @schedule.cohort
  end

  def update
    @schedule = Schedule.find(params[:id])
    @schedule.update(schedule_params)
    redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
  end

  def destroy
    @schedule = Schedule.find(params[:id])
    @schedule.destroy
    redirect_to cohort_path(@schedule.cohort)
  end

  def generate_blog_rotation
    @schedule = Schedule.find(params[:id])
    @schedule.cohort.blog_assignments.all.destroy_all
    @priority = params[:priority]

    if @priority == "adhere to specified frequency"
      @schedule.generate_blog_assignments
    else
      @schedule.generate_blog_assignments_based_on_students_per_day
    end
    
    flash[:priority] = @priority
    redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
  end

  def set_blog_rotation
    @schedule = Schedule.find(params[:id])
    @schedule.toggle!(:rotation_locked)
    redirect_to(:back)

    # if @schedule.rotation_locked
    #   @schedule.students.each do |student|
    #     StudentMailer.initial_schedule_notification(@schedule, student).deliver_now
    #   end
    # end
  end

  private

    def schedule_params
      params.require(:schedule).permit(:name, :start_date, :end_date, :cohort_id, :frequency, :blog_assignments_attributes => [:student_id, :due_date, :schedule_id, :id])
    end
end
