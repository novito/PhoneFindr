class DevicePage < ActiveRecord::Base
  belongs_to :category_url

  validates :category_url, presence: true
  validates :url, presence: true
end
