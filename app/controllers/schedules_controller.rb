class SchedulesController < ApplicationController
  before_action :set_schedule, except: [:new, :create]
  
  def show
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

  def edit
    @cohort = @schedule.cohort
  end

  def update
    @schedule.update(schedule_params)
    redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
  end

  def destroy
    @schedule.destroy
    redirect_to cohort_path(@schedule.cohort)
  end

  def generate_blog_rotation
    @schedule.cohort.blog_assignments.all.destroy_all
    @priority = params[:priority]

    if @priority == "adhere to specified frequency"
      @schedule.generate_blog_assignments
    else
      @schedule.generate_blog_assignments_based_on_users_per_day
    end
    
    redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
  end

  def set_blog_rotation
    @schedule.toggle!(:rotation_locked)
    redirect_to(:back)

    if @schedule.rotation_locked
      @schedule.users.each do |user|
        UserMailer.initial_schedule_notification(@schedule, user).deliver_later if user.blog_assignments.any?
      end
    end
  end

  private

    def schedule_params
      params.require(:schedule).permit(:name, :start_date, :end_date, :cohort_id, :frequency, :blog_assignments_attributes => [:user_id, :due_date, :schedule_id, :id])
    end

    def set_schedule
      @schedule = Schedule.find(params[:id])
    end
end
