class CohortsController < ApplicationController
  before_action :set_cohort, except: [:create, :show, :index]
  # before_action :require_admin_status

  def create
    @cohort = Cohort.new(cohort_params)
    if @cohort.save
      flash[:success] = "Cohort successfully created!"
    else
      flash[:alert] = @cohort.errors.full_messages.to_sentence
    end
    redirect_to(:back)
  end

  def edit
  end

  def update
    @cohort.update(cohort_params)
    redirect_to(cohort_path(@cohort))
  end

  def show
    @cohort = Cohort.find(params[:id])
    
    # order the users by last_name, and if there's no last_name use github_username in its place
    @users = @cohort.users.order("COALESCE(NULLIF(lower(last_name), ''), lower(github_username))")
  end

  def index
    @cohorts = Cohort.all
    @cohort = Cohort.new
    gon.holidays = Holiday.all.pluck(:date).map{|date| date.strftime("%m/%d/%Y")}.join(" ")
  end

  def destroy
    @cohort.destroy
    redirect_to(:back)
  end

  def get_new_posts
    @cohort.blogs.each do |blog|
      blog.create_entries
    end
    flash[:success] = "New posts successfully retrieved!"
    redirect_to(:back)
  end

  private

    def cohort_params
      params.require(:cohort).permit(:name, :roster_csv)
    end

    def set_cohort
      @cohort = Cohort.find(params[:id])
    end
end
