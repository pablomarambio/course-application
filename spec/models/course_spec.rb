describe Course do

  before(:each) { @course = FactoryGirl.create :course }

  subject { @course }

  it {should respond_to(:name)}
  it {should validate_presence_of :name}

  it {should validate_presence_of :classroom}

  it {should validate_presence_of :capacity}

  it {should belong_to :block}


end