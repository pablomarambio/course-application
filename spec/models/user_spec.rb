describe User do

  before(:each) { @user = FactoryGirl.create :user }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:rut) }

  it {should validate_presence_of :email}
  it {should validate_presence_of :name}
  it {should validate_presence_of :rut}
  it {should validate_uniqueness_of  :rut}

  it {should define_enum_for :role}

  it {should belong_to :course_batch}

  it "student can be assigned to only one course in a block"

end