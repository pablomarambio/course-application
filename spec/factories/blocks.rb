FactoryGirl.define do

  factory :block do
    time = Faker::Time.forward(30)
    name {Faker::Lorem.word}
    from {time.strftime("%I:%M%p")}
    to {(time+1.hours).strftime("%I:%M%p")}
    course_batch_id 1

    factory :block_with_courses do
      after(:build) do |block, eval|
        block.courses << FactoryGirl.build_list(:course, 3)
      end
    end

  end

end
