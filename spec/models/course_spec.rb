describe Course do

  before(:each) { @course = FactoryGirl.create :course }

  subject { @course }

  it {should respond_to(:name)}
  it {should validate_presence_of :name}
  it {should validate_uniqueness_of  :name}

  # it {should respond_to(:to)}
  # it {should validate_presence_of :to}
  # it {should respond_to(:from)}
  # it {should validate_presence_of :from}
  it {should respond_to(:classroom)}

  it {should validate_presence_of :classroom}
  it {should respond_to(:capacity)}

  it {should validate_presence_of :capacity}

  it {should belong_to :block}
  it {should belong_to :course_batch}

  it { should have_many(:applications).dependent(:destroy) }
  it { should have_many(:results).dependent(:destroy) }




end