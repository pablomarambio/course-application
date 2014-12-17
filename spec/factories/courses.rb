FactoryGirl.define do

  factory :course do
    sequence :name do |n|
      "name#{n}"
    end
    classroom {Faker::Number.digit}
    capacity {Faker::Number.number(2)}
    # from "10"
    # to "12"
  end

end