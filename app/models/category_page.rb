class CategoryPage < ActiveRecord::Base
  belongs_to :source
  has_many :device_pages

  validates :url, presence: true
  validates :url, url:true
  validates :name, presence:true 
  validates :source, presence:true

end
