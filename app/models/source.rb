require 'uri'

class Source < ActiveRecord::Base
  has_many :category_urls

  validates :name, :url, presence: true
  validates :url, url:true
end
