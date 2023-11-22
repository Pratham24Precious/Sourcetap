require 'faker'

FactoryBot.define do
  factory :job, class: Job do
    title { Faker::Job.title }
    description { Faker::Lorem.sentence }
    skills_required { Faker::Job.key_skill }
    experience_level { ['Entry-level', 'Mid-level', 'Senior-level'].sample }
    location { Faker::Address.city }
    salary_range { "#{Faker::Number.between(from: 50000, to: 100000)} - #{Faker::Number.between(from: 100000, to: 150000)}" }
    application_deadline { Date.today + rand(30..90).days }
    contact_email { Faker::Internet.email }
    contact_phone { Faker::PhoneNumber.phone_number }
    association :recruiter, factory: :recruiter
  end
end