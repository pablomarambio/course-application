include Warden::Test::Helpers
Warden.test_mode!

feature 'Admin for Courses', :devise do

  before(:all) do
    @user = FactoryGirl.create(:user, :admin)
    @courses =FactoryGirl.create_list(:course,5)
  end

  before(:each) do
    login_as(@user, :scope => :user)
  end

  after(:each) do
    Warden.test_reset!
  end

  scenario 'admin can view courses listing index' do
    visit "/admin/m/Course"
    test_course = @courses.sample
    expect(page).to have_content test_course.name
    expect(page).to have_content test_course.classroom
    expect(page).to have_content test_course.block_id
    expect(page).to have_content test_course.capacity
  end

  scenario 'admin can create a new course' do
    course_count = Course.count
    visit "/admin/m/Course/new"
    fill_in :course_name, with:"test1234"
    fill_in :course_classroom, with:"test1234"
    fill_in :course_block_id, with:"1"
    fill_in :course_capacity, with:"12"
    click_button "Create"
    expect(page).to have_content "Course created successfully"
    expect(Course.count).to eq course_count + 1
  end

  scenario 'admin can edit course' do
    test_course = @courses.sample
    visit "/admin/m/Course/i/#{test_course.id}"
    fill_in 'course_name', with: "CHANGED"
    click_button "Save"
    expect(page).to have_content "Course updated successfully"
    expect(test_course.reload.name).to eq "CHANGED"
  end

  scenario 'admin can delete a course from index' do
    test_course = @courses.sample
    visit "/admin/m/Course"
    find(".delete_course_#{test_course.id}").click
    expect(current_path).to eq "/admin/m/Course"
    expect(page).to_not have_content test_course.name
  end

end

