class BlogsController < ApplicationController
  def index
    @blogs = Blog.all
  end

  def create
    @blog = Blog.create(blog_params)
    redirect_to(:back)
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to(:back)
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    @blog.update(blog_params)
    redirect_to(cohort_path(@blog.cohort))
  end

  private

    def blog_params
      params.require(:blog).permit(:url, :user_id)
    end
end
