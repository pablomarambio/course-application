describe Result do

  before(:each) { @result = FactoryGirl.create :result }

  subject { @result }


  it {should belong_to :user}
  it {should belong_to :course}
  it {should belong_to :block}

  it "should check if student is assigned to the blocks batch"

  it "should check if student has applied for this course/block/batch"

  it "should check if student is not already assigned to some other course in this block"

end