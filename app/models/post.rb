class Post < ActiveRecord::Base
  belongs_to :blog
  has_one :blog_assignment
  delegate :user, to: :blog
  validates_uniqueness_of :url
  validates_presence_of :url, :title

  def title_and_date
    "#{title} - #{published_date.strftime("%m/%d/%Y")}"
  end

  def content_or_summary
    content || summary
  end

  def slugified_title
    title.gsub(" ", "-").downcase.gsub(/(?!-)\W/, "")
  end

  def name_for_wordpress
    slugified_title.prepend("/")
  end

  def content_for_wordpress
    original_credit_for_wordpress + content
  end

  def original_credit_for_wordpress
    "<strong>This post originally appeared on #{user.full_name_or_github_name}'s blog. Read more at <a href=#{user.blog.url}>#{user.blog.title}</a>.</strong><br><br>"
  end

  def blurb
    lines = (ActionController::Base.helpers.strip_tags(content_or_summary)).split("\n")
    blurb = ""
    n = 0
    until blurb.length >= 200 || !lines[n]
      blurb << lines[n] if !lines[n].match(/&lt/)
      blurb << "\n"
      n += 1
    end
    blurb.gsub(/<img.+\>/, "")
  end

end
