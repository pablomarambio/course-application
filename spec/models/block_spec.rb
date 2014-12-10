describe Block do

  before(:each) { @block = FactoryGirl.create :block_with_courses }

  subject { @block }

  it {should belong_to :course_batch}

  it {should respond_to(:name)}
  it {should validate_presence_of :name}

  it {should respond_to(:from)}
  it {should validate_presence_of :from}

  it {should respond_to(:to)}
  it {should validate_presence_of :to}

  it "should validate courses count to be greater than 0" do
    @block_without_courses = FactoryGirl.build(:block)
    expect(@block_without_courses.valid?).to eq false
  end

end