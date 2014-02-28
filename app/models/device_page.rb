class DevicePage < ActiveRecord::Base
  belongs_to :category_parsing_result
  has_one :page

  validates :category_parsing_result, presence: true
  validates :url, presence: true
end
