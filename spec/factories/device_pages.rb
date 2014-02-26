# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device_page do
    url "http://www.gsmarena.com/nokia_lumia_1320-5791.php"
    category_parsing_result
  end
end
