require 'uri'

class Source < ActiveRecord::Base
  has_many :category_pages

  validates :name, :url, presence: true
  validates :url, url:true
end
