class WordPress
  def self.client
    Rubypress::Client.new(
      :host => "flatirontestblog.wordpress.com", 
      :username => ENV["wordpress_username"], 
      :password => ENV["wordpress_password"]
    )
  end

  def self.publish_to_wordpress(post)
    client.newPost( 
      :blog_id => "0", # 0 unless using WP Multi-Site, then use the blog id
      :content => {
        :post_status  => "publish",
        :post_date    => Time.now,
        :post_content => post.content,
        :post_title   => post.title,
        :post_name    => post.name_for_wordpress,
        :post_author  => 1, # 1 if there is only the admin user, otherwise the user's id
      }
    )
  end
end
