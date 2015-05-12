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
    session[:from_uri] = request.env["HTTP_REFERER"]
    @blog = Blog.find(params[:id])
  end

  def update
    @blog = Blog.find(params[:id])
    if @blog.update(blog_params)
      flash[:success] = "Blog successfully updated!"
      redirect_uri = session[:from_uri]
      session[:from_uri] = nil
      redirect_to(redirect_uri)
    else
      flash[:alert] = @blog.errors.full_messages.to_sentence
      redirect_to(:back)
    end
  end

  private

    def blog_params
      params.require(:blog).permit(:url, :user_id)
    end
end
