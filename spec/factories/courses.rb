FactoryGirl.define do

  factory :course do
    name {Faker::Lorem.word}
    classroom {Faker::Number.digit}
    capacity {Faker::Number.number(2)}
    # from "10"
    # to "12"
  end

end