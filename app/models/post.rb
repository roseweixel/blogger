class Post < ActiveRecord::Base
  belongs_to :blog
  validates_uniqueness_of :url
  validates_presence_of :url, :title

  def slugified_title
    title.gsub(" ", "-").downcase.gsub(/(?!-)\W/, "")
  end

  def name_for_wordpress
    slugified_title.prepend("/")
  end
end
