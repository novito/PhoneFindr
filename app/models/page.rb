class Page < ActiveRecord::Base
  belongs_to :category_parsing_result

  validates :category_parsing_result, presence: true
  validates :url, presence: true
end
