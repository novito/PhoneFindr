require 'uri'

class Source < ActiveRecord::Base
  has_many :category_pages, :dependent => :destroy

  validates :name, :url, presence: true
  validates :url, url:true
end
