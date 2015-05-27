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
    lines = content.split("\n")
    blurb = ""
    n = 0
    until (blurb.count("<p") >= 4 && blurb.length >= 200) || !lines[n]
      blurb << lines[n] if !lines[n].include?("<code") && !lines[n].include?("</code>") && !lines[n].include?("figure class='code'")
      blurb << "\n"
      n += 1
    end
    blurb.gsub(/<img.+\>/, "")
  end

end
