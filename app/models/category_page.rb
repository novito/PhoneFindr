class CategoryPage < ActiveRecord::Base
  belongs_to :source
  belongs_to :brand
  has_many :category_parsing_results, :dependent => :destroy

  validates :url, presence: true
  validates :url, url:true
  validates :name, presence:true 
  validates :source, presence:true
  validates :brand, presence:true

  def last_parsed_result
    self.category_parsing_results.ordered.first
  end
end
