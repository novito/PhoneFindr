# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category_page do
    source
    brand
    name 'Nokia phones'
    url "http://www.gsmarena.com/nokia-phones-1.php"

    factory :category_page_with_parsed_results do
      after(:create) do |cat_page|
        create_list(:category_parsing_result, 1, category_page: cat_page)
      end
    end
  end
end
