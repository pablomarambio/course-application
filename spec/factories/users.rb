FactoryGirl.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {Faker::Internet.password}
    rut {Faker::Number.number(10)}


    trait :admin do
      role 'admin'
    end

  end
end
