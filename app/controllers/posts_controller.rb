class PostsController < ApplicationController
  before_action :require_admin_status, except: [:index]

  def feature_post
    wpc = WordPress.client
    url = wpc.authorize_url("http://localhost:3000/publish_posts")
    redirect_to url
  end

  def publish_posts
    @posts = Post.all
    code = params[:code]
    wpc = WordPress.client
    wpc.get_token(code, "http://localhost:3000/publish_posts")
    session[:wordpress_auth] = wpc.serialize
  end

  def publish_post
    wpc = WordpressCom.deserialize(session[:wordpress_auth])
    @post = Post.find(params[:post_id])
    success = wpc.post('posts/new', :body => {
      :title => @post.title,
      :content => @post.content
    })
    flash[:success] = "#{@post.title} was successfully published to the Flatiron School blog!"
    redirect_to cohorts_path
  end

  def index
    @posts = Post.all.order(published_date: :desc)
  end
end
