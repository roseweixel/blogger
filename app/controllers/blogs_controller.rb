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

  private

    def blog_params
      params.require(:blog).permit(:url, :student_id)
    end
end
