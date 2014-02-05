require 'uri'

class Sources < ActiveRecord::Base
  validates :name, :url, presence: true
  validates :url, url:true
end
