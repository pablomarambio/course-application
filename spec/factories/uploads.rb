FactoryGirl.define do
  factory :upload do
    file "MyText"

    trait :users do
      upload_type :users
      file {File.open("spec/test_files/students.csv", "r:UTF-8").read}
    end

    trait :users_with_missing_columns do
      upload_type :users
      file {File.open("spec/test_files/students_with_missing_columns.csv", "r:UTF-8").read}
    end

    trait :users_with_blanks do
      upload_type :users
      file {File.open("spec/test_files/students_with_blanks.csv", "r:UTF-8").read}
    end

    trait :courses do
      upload_type :courses
      file {File.open("spec/test_files/courses.csv", "r:UTF-8").read}
    end

    trait :courses_with_missing_columns do
      upload_type :courses
      file {File.open("spec/test_files/courses_with_missing_columns.csv", "r:UTF-8").read}
    end

    trait :results do
      upload_type :results
      file {File.open("spec/test_files/results.csv", "r:UTF-8").read}
    end

    trait :results_with_missing_columns do
      upload_type :results
      file {File.open("spec/test_files/results_with_missing_columns.csv", "r:UTF-8").read}
    end


  end

end