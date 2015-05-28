class Post < ActiveRecord::Base
  belongs_to :blog
  delegate :user, to: :blog
  validates_uniqueness_of :url
  validates_presence_of :url, :title, :content

  def slugified_title
    title.gsub(" ", "-").downcase.gsub(/(?!-)\W/, "")
  end

  def name_for_wordpress
    slugified_title.prepend("/")
  end

  def blurb
    lines = (ActionController::Base.helpers.strip_tags(content)).split("\n")
    blurb = ""
    n = 0
    until blurb.length >= 200 || !lines[n]
      blurb << lines[n] if !lines[n].match(/&lt/)
      blurb << "\n"
      n += 1
    end
    blurb
  end

end
