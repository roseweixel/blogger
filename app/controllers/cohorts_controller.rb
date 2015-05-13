class CohortsController < ApplicationController
  before_action :require_admin_status

  def create
    @cohort = Cohort.create(cohort_params)
    if @cohort.persisted? && @cohort.roster_csv
      @cohort.create_members
    elsif !@cohort.persisted?
      flash[:alert] = "This cohort could not be created!"
    end
    redirect_to(:back)
  end

  def edit
    @cohort = Cohort.find(params[:id])
  end

  def update
    @cohort = Cohort.find(params[:id])
    @cohort.update(cohort_params)
    redirect_to(cohort_path(@cohort))
  end

  def show
    @cohort = Cohort.includes(users: [:blogs]).find(params[:id])
  end

  def index
    @cohorts = Cohort.all
    @cohort = Cohort.new
  end

  def destroy
    @cohort = Cohort.find(params[:id])
    @cohort.destroy
    redirect_to(:back)
  end

  def get_new_posts
    @cohort = Cohort.find(params[:cohort_id])
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
end
