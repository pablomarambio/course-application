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

  it "has at least one course" do
    @block_without_courses = FactoryGirl.build(:block)
    expect(@block_without_courses.valid?).to eq false
  end

  it "can have multiple courses" do
    @block.courses << FactoryGirl.create(:course)
    @block.courses << FactoryGirl.create(:course)
    expect(@block.courses.count).to eq 5
  end

end