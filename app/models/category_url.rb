class CategoryUrl < ActiveRecord::Base
  belongs_to :source

  validates :url, presence: true
  validates :url, url:true
  validates :source, presence:true
end
