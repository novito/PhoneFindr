# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category_page do
    source
    last_parsed "2014-02-05 08:46:18"
    name 'Nokia phones'
    url "http://www.gsmarena.com/nokia-phones-1.php"
  end
end
