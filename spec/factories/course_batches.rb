FactoryGirl.define do
  factory :course_batch do
    name {Faker::Lorem.word}


    trait :with_blocks do
      after(:build) do |course_batch, eval|
        course_batch.blocks << FactoryGirl.build(:block_with_courses)
        course_batch.blocks << FactoryGirl.build(:block_with_courses)
      end
    end

  end

end
