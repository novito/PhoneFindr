# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'laciega@gmail.com'
    password 'vaxjovaxjo'

    trait :admin do
      admin true
    end

    trait :not_admin do
      admin false
    end
  end
end
