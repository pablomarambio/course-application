describe Application do

  before(:each) { @application = FactoryGirl.create :application }

  subject { @application }

  it { should respond_to(:priority) }

  it {should validate_presence_of :priority}

  it {should belong_to :user}
  it {should belong_to :course}


end