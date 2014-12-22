FactoryGirl.define do
  factory :application do
    user_id 1
    course_id 1
    priority {Faker::Number.digit}
  end

end
