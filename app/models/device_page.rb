class DevicePage < ActiveRecord::Base
  belongs_to :category_page

  validates :category_page, presence: true
  validates :url, presence: true
end
