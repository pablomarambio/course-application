FactoryGirl.define do
  factory :course_batch do
    name {Faker::Lorem.word}


    trait :with_blocks do
      after(:build) do |course_batch, eval|
        course_batch.blocks << FactoryGirl.build_list(:block_with_courses, 2)
      end
    end

  end

end
