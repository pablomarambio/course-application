FactoryGirl.define do
  factory :upload do
    upload_type :users
    file "MyText"

    trait :users do
      upload_type :users
      file {File.open("spec/test_files/students.csv", "r:UTF-8").read}
    end

    trait :courses do
      upload_type :courses
      file {File.open("spec/test_files/courses.csv", "r:UTF-8").read}
    end

    trait :courses do
      upload_type :results
      file {File.open("spec/test_files/results.csv", "r:UTF-8").read}
    end

  end

end