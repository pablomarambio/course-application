describe CourseBatch do

  before(:each) { @course_batch = FactoryGirl.create :course_batch }

  subject { @course_batch }

  it {should respond_to(:name)}

  it {should validate_presence_of :name}


  it "should have open_status set to true" do
    expect(@course_batch.open_status).to eq true
  end

end