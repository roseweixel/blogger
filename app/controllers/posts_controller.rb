class PostsController < ApplicationController

  def filter
    filter_attribute = params[:filter_attribute]
    
    @cohort = Cohort.find_by(name: filter_attribute)
    @posts = get_filtered_posts(filter_attribute)

    respond_to do |f|
      f.js
    end
  end

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

    flash[:success] = "#{@post.title} was successfully published to your WordPress blog with draft status."
    redirect_to cohorts_path
  end

  def index
    @posts = Post.all.order(published_date: :desc)
  end

  private

    def get_filtered_posts(filter_attribute)
      @cohort ? Post.posts_for_cohort(@cohort) : Post.all
    end

    def publish_post_to_wordpress
      @wpc.post('posts/new', :body => {
        :title => @post.title,
        :content => @post.content_for_wordpress,
        :status => 'draft'
      })
    end

    def wordpress_redirect_url
      request.base_url + publish_posts_path
    end
end
