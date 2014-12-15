FactoryGirl.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {Faker::Internet.password}
    rut {Faker::Number.number(10)}


    trait :admin do
      role 'admin'
    end

    trait :with_batch do
      after(:build) do |user, eval|
        user.course_batch = FactoryGirl.create(:course_batch, :with_blocks)
        user.save
      end
    end

    trait :idle do
      after(:build) do |user, eval|
        user.course_batch = FactoryGirl.create(:course_batch, :with_blocks)
        user.save
      end
    end

    trait :completed_application do
      after(:build) do |user, eval|
        #create N applications for all courses
        user.course_batch = FactoryGirl.create(:course_batch, :with_blocks)
        user.save
        user.course_batch.blocks.each do |block|
          block.courses.each_with_index do |course, index|
            user.applications << Application.create(course_id: course.id, priority: index)
          end
        end
      end
    end

    trait :incompleted_application do
      after(:build) do |user, eval|
        #create N applications for all courses
        user.course_batch = FactoryGirl.create(:course_batch, :with_blocks)
        user.save
        user.course_batch.blocks.each do |block|
          block.courses.each_with_index do |course, index|
            user.applications << Application.create(course_id: course.id, priority: index)
          end
        end
        user.applications.sample.destroy
      end
    end

  end
end
