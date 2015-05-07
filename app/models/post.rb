class Post < ActiveRecord::Base
  belongs_to :blog
  validates_uniqueness_of :url
  validates_presence_of :url, :title
end
