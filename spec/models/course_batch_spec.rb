describe CourseBatch do

  before(:each) { @course_batch = FactoryGirl.create :course_batch, :with_blocks }

  subject { @course_batch }

  it {should respond_to(:name)}

  it {should validate_presence_of :name}


  it "has open_status set to true" do
    expect(@course_batch.open_status).to eq true
  end

  it "has at least one block" do
    @batch_without_blocks = FactoryGirl.build(:course_batch)
    expect(@batch_without_blocks.valid?).to eq false
  end

  it "can have multiple blocks" do
    @course_batch.blocks << FactoryGirl.create(:block_with_courses)
    @course_batch.blocks << FactoryGirl.create(:block_with_courses)
    expect(@course_batch.blocks.count).to eq 4
  end

end