describe Upload do

  before(:each) { @upload = FactoryGirl.create :upload }

  subject { @upload }

  it { should respond_to(:upload_type) }
  it { should respond_to(:file) }
  it { should respond_to(:rows)}
  it {should respond_to(:process_file)}
  it {should respond_to(:process_row)}

  it {should validate_presence_of :upload_type}
  it {should validate_presence_of :file}


  context "users upload" do

    before (:each) { @users_upload = FactoryGirl.create(:upload, :users)}

    subject {@users_upload}

    it "should read CSV file and split it into rows" do
      expect(subject.rows.count).to eq 10
    end

    it "should create user from CSV row without id" do
      subject.process_row(1)
      expect(subject.upload_results[0].message).to eq "User created"
      expect(subject.upload_results[0].result_type).to eq "Success"
      @test_user = User.last
      expect(@test_user.nil?).to eq false
      expect(@test_user.name).to eq "Pablo"
      expect(@test_user.rut).to eq "14569484"
      expect(@test_user.reload.email).to eq "pablo@pablo.com"
      expect(@test_user.encrypted_password.nil?).to eq false
      expect(@test_user.course_batch_id).to eq 1
    end

    it "should delete user from CSV row with only id" do
      @test_user = FactoryGirl.create(:user, id: 230)
      subject.process_row(5)
      expect(User.where(id:230).blank?).to eq true
    end

    it "should update user from CSV row with id" do
      @test_user = FactoryGirl.create(:user, id:280, name:"test", rut: "123123123", email:"test@test.com", password: "test1234", course_batch_id: 5)
      subject.process_row(7)
      expect(subject.upload_results[0].message).to eq "User updated"
      expect(subject.upload_results[0].result_type).to eq "Success"
      expect(@test_user.reload.name).to eq "Carlos"
      expect(@test_user.reload.rut).to eq "8457638"
      expect(@test_user.reload.email).to eq "test@test.com"
      expect(@test_user.reload.course_batch_id).to eq 1
    end

    it "should return error for a row with blanks" do
      subject.process_row(8)
      expect(subject.upload_results[0].message).to eq "Password can't be blank"
      expect(subject.upload_results[0].result_type).to eq "Error"
    end

    it "should return error for a row for non unique RUT" do
      @another_user = FactoryGirl.create(:user, id:280, name:"test", rut: "14569484", email:"test@test.com", password: "test1234", course_batch_id: 5)
      @test_user = FactoryGirl.create(:user, id:300,  name:"Cristóbal", rut:"1231313132", password: "efe443asd")
      subject.process_row(9)
      expect(subject.upload_results[0].message).to eq "Rut has already been taken"
      expect(subject.upload_results[0].result_type).to eq "Error"
    end

    it "should return error for a row with non existent ID when deleting" do
      subject.process_row(10)
      expect(subject.upload_results[0].message).to eq "User not found"
      expect(subject.upload_results[0].result_type).to eq "Error"
    end

  end

  context "courses upload" do

    it "should read CSV file and split it into rows"

    it "should create course from CSV row without id"

    it "should delete course from CSV row with only id"

    it "should update course from CSV row with id"

    it "should return error for a row with blanks"

    it "should return error for a row for non unique name"

    it "should return error for a row with non existent ID when deleting"


  end

end
