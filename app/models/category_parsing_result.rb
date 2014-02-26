class CategoryParsingResult < ActiveRecord::Base
  scope :ordered, -> { order('date DESC') }
  belongs_to :category_page
  has_many :device_pages

  validates :date, presence:true 
end
