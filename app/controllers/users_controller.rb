class UsersController < ApplicationController
  before_action :set_user, except: [:create, :index]
  before_action :require_admin_status, only: [:index, :destroy]
  before_action :verify_identity
  
  def create
    @user = User.new(user_params)
    if @user.save
      cohort = Cohort.find(params[:user][:cohort]) if params[:user][:cohort]
      Membership.create(user_id: @user.id, cohort_id: cohort.id) if cohort
      redirect_to(:back)
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      redirect_to(:back)
    end
  end

  def show
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to(cohort_path(@user.cohort))
  end

  def index
    @users = User.all
  end

  def destroy
    @user.destroy
    redirect_to(:back)
  end

  def get_new_posts
    @user = User.find(params[:id])
    @user.blogs.each do |blog|
      blog.create_entries
    end
    flash[:success] = "New posts successfully retrieved!"
    redirect_to(:back)
  end

  private 

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :github_username)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def verify_identity
      if !current_user.admin && @user != current_user
        flash[:alert] = "You're not allowed to see that!"
        redirect_to root_path
      end
    end
end
