require 'faker'

FactoryBot.define do
  factory :recruiter, class: Recruiter do
    name { Faker::Name.unique.first_name }
    email { Faker::Internet.unique.email }
    company_name { Faker::Company.name }
    city { 'Example City' }
    password { 'password123' }
    mobile_no { Faker::Base.numerify('91989#######') }

  end
end
