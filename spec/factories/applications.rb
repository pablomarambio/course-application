FactoryGirl.define do
  factory :application do
    # student_id 1
    # course_id 1
    priority {Faker::Number.digit}
  end

end
