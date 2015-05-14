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

  def first_two_paragraphs
    content_array = content.split("<p>")
    string = ""
    2.times do |n|
      if content_array[n+1] && content_array[n+1].class == String
        string << "<p>"
        string << content_array[n+1]
      end
    end
    string
  end

end
