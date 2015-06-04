class BlogsController < ApplicationController
  before_action :set_blog, except: [:index, :create]

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
    @blog.destroy
    redirect_to(:back)
  end

  def edit
    set_from_uri
  end

  def update
    if @blog.update(blog_params)
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
end
