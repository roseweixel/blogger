class PostsController < ApplicationController
  before_action :require_admin_status, except: [:index]

  def feature_post
    wpc = WordPress.client
    url = wpc.authorize_url(wordpress_redirect_url)
    redirect_to url
  end

  def publish_posts
    @posts = Post.all
    code = params[:code]
    wpc = WordPress.client
    wpc.get_token(code, wordpress_redirect_url)
    session[:wordpress_auth] = wpc.serialize
  end

  def publish_post
    @post = Post.find(params[:id])
    @wpc = WordpressCom.deserialize(session[:wordpress_auth])

    publish_post_to_wordpress

    flash[:success] = "#{@post.title} was successfully published to the Flatiron School blog!"
    redirect_to cohorts_path
  end

  def index
    @posts = Post.all.order(published_date: :desc)
  end

  private

    def publish_post_to_wordpress
      @wpc.post('posts/new', :body => {
        :title => @post.title,
        :content => @post.content
      })
    end

    def wordpress_redirect_url
      "http://localhost:3000/publish_posts"
    end
end
