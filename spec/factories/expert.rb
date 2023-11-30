require 'faker'

FactoryBot.define do
  factory :expert, class: Expert do
    name { Faker::Name.unique.first_name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    skills { 'Ruby, Rails' }
    experience { 5 }
    mobile_no { Faker::Base.numerify('91989#######') }
    current_city { 'Example City' }
  end
end
