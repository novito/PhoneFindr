class Brand < ActiveRecord::Base
  has_many :category_pages

  validates :name, presence:true 
  validates :name, uniqueness:true
end
