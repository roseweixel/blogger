class BlogsController < ApplicationController
  before_action :set_blog, except: [:index, :create]
  # before_action :verify_admin_or_blog_owner, except: [:index]

  def index
    @blogs = Blog.all
  end

  def create
    @blog = Blog.new(blog_params)
    if @blog.save
      flash[:success] = "Blog successfully created!"
      flash[:alert] = "The feed for this blog could not be parsed. Please enter the feed url on #{@blog.user.full_name_or_github_name}'s profile page." if @blog.feed == {}
    else
      flash[:alert] = @blog.errors.full_messages.to_sentence
    end
    redirect_to(:back)
  end

  def destroy
    if @blog.destroy
      flash[:success] = "Blog successfully destroyed."
    else
      flash[:alert] = @blog.errors.full_messages.to_sentence
    end
    redirect_to(:back)
  end

  def edit
    set_from_uri
  end

  def update
    old_url = @blog.url
    if @blog.update(blog_params)
      # if @blog.url has changed, clear the old title and posts and fetch the new ones
      @blog.reset_if_url_changed(old_url)
      flash[:success] = "Blog successfully updated!"
      if session[:from_uri]
        redirect_to_from_uri
      else
        redirect_to(:back)
      end
    else
      flash[:alert] = @blog.errors.full_messages.to_sentence
      redirect_to(:back)
    end
  end

  def reset
    @blog.reset
    redirect_to(:back)
  end

  private

    def blog_params
      params.require(:blog).permit(:url, :user_id, :feed_url)
    end

    def set_blog
      @blog = Blog.find(params[:id])
    end

    def verify_admin_or_blog_owner
      unless current_user.admin || (@blog && (current_user == @blog.user)) || blog_params[:user_id].to_i == current_user.id
        flash[:alert] = "You must be admin or the owner of the blog in order to do this!"
        redirect_to(:back)
      end
    end
end
