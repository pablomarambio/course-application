describe CourseBatch do

  before(:each) { @course_batch = FactoryGirl.create :course_batch, :with_blocks }

  subject { @course_batch }

  it {should respond_to(:name)}

  it {should validate_presence_of :name}

  it {should have_many :users}

  it {should respond_to :courses}

  it {should respond_to :status}

  it ".courses should return courses for all blocks" do
    expect(subject.courses).to eq subject.blocks.collect{|b| b.courses}.flatten
  end



  it "has open_status set to true" do
    expect(subject.open_status).to eq true
  end

  it "has at least one block" do
    @batch_without_blocks = FactoryGirl.build(:course_batch)
    expect(@batch_without_blocks.valid?).to eq false
  end

  it "can have multiple blocks" do
    subject.blocks << FactoryGirl.create(:block_with_courses)
    subject.blocks << FactoryGirl.create(:block_with_courses)
    expect(subject.blocks.count).to eq 4
  end

end