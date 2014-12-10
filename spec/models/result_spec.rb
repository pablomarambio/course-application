describe Result do

  before(:each) { @result = FactoryGirl.create :result }

  subject { @result }


  it {should belong_to :user}
  it {should belong_to :course}
  it {should belong_to :block}

end