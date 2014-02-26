FactoryGirl.define do
  factory :category_parsing_result do
    category_page
    date Date.parse('2012-01-01') 
  end
end
