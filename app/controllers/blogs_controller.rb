class BlogsController < ApplicationController
  before_action :set_blog, except: [:index, :create]

  def index
    @blogs = Blog.all
  end

  def create
    @blog = Blog.create(blog_params)
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
      redirect_to_from_uri
    else
      flash[:alert] = @blog.errors.full_messages.to_sentence
      redirect_to(:back)
    end
  end

  private

    def blog_params
      params.require(:blog).permit(:url, :user_id)
    end

    def set_blog
      @blog = Blog.find(params[:id])
    end
end
