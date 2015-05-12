class UsersController < ApplicationController

  def create
    @user = User.create(user_params)
    cohort = Cohort.find(params[:user][:cohort]) if params[:user][:cohort]
    Membership.create(user_id: @user.id, cohort_id: cohort.id) if cohort
    redirect_to(:back)
  end

  def show
    @user = User.includes(:blog_assignments).find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to(cohort_path(@user.cohort))
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to(:back)
  end

  private 

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :github_username)
    end
end
