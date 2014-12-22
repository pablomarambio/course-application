FactoryGirl.define do

  factory :course do
    sequence :name do |n|
      "name#{n}"
    end
    classroom {Faker::Number.digit}
    capacity {Faker::Number.number(2)}
    course_batch_id 1

  end

end