FactoryGirl.define do

  factory :course do
    name {Faker::Lorem.word}
    classroom {Faker::Number.digit}
    capacity {Faker::Number.number(2)}
  end

end