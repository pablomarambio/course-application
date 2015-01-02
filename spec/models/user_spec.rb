describe User do

  before(:each) { @user = FactoryGirl.create :user }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:rut) }
  it { should respond_to(:login)}
  it { should respond_to(:login=)}
  it {should respond_to(:applications_for_block)}
  it {should respond_to(:switch_applications)}

  it {should validate_presence_of :email}
  it {should validate_presence_of :name}
  it {should validate_presence_of :rut}
  it {should validate_uniqueness_of  :rut}

  it {should validate_numericality_of :rut}

  it {should define_enum_for :role}

  it {should belong_to :course_batch}
  it {should have_many :applications}
  it {should have_many :results}

  it "can be assigned to a course batch" do
    @course_batch = FactoryGirl.create(:course_batch, :with_blocks)
    @user.course_batch = @course_batch
    @user.save
    expect(@user.course_batch).to eq @course_batch
  end

  it "can have multiple applications" do
    @user.applications << FactoryGirl.create(:application)
    @user.applications << FactoryGirl.create(:application)
    expect(@user.applications.count).to eq 2
  end

  # Number of students with completed applications, that is, students with N applications, where N is the number of courses contained within the student's course batch.
  it "returns number of students with completed applications" do
      #create student with N courses in batch
      @test_user = FactoryGirl.create(:user, :with_batch)
      #create N applications for all courses
      @test_user.course_batch.blocks.each do |block|
          block.courses.each_with_index do |course, index|
              @test_user.applications << Application.create(course_id: course.id, priority: index)
          end
      end
      #test the method
      expect(User.with_completed_applications.count).to eq 1
  end

  # Number of students with incomplete applications, that is, students with more than 1 and less than N applications, where N is the number of courses contained within the student's course batch.
  it "returns number of students with incomplete applications" do
    #create student with N courses in batch
    @test_user = FactoryGirl.create(:user, :with_batch)
    #create N-1 applications for all courses
    @test_user.course_batch.blocks.each do |block|
        block.courses.each_with_index do |course, index|
            @test_user.applications << Application.create(course_id: course.id, priority: index)
        end
        @test_user.applications.last.destroy
    end
    #test the method
    expect(User.with_incompleted_applications.count).to eq 1
  end

  # Number of "idle students", that is, students that haven't submitted any application
  it "returns number of students who are idle (zero applications)" do
    @test_user = FactoryGirl.create(:user)
    expect(User.idle.count).to eq 2
  end

  it "returns array of aplications, for given block, sorted by priority" do
    @test_user = FactoryGirl.create(:user, :with_batch)
    @block = @test_user.course_batch.blocks.first
    @applications = @test_user.applications_for_block(@block)
    @applications_for_block = []
    @block.courses.each do |course|
        @applications_for_block << Application.where(user_id:@test_user.id, course_id: course.id).first
    end
    expect(@applications).to eq @applications_for_block
    expect(@applications.first.priority).to eq 1
    expect(@applications.last.priority).to eq @applications.count
  end

  it "moves application up in the array of applications" do
    @test_user = FactoryGirl.create(:user, :with_batch)
    @block = @test_user.course_batch.blocks.first
    @applications = @test_user.applications_for_block(@block)
    @application1 = @applications.first
    @application2 = @applications.second
    @test_user.switch_applications(@application2, @application1)
    expect(@application2.reload.priority).to eq 1
    expect(@application1.reload.priority).to eq 2
  end

  it "moves application down in the array of applications" do
    @test_user = FactoryGirl.create(:user, :with_batch)
    @block = @test_user.course_batch.blocks.first
    @applications = @test_user.applications_for_block(@block)
    @application1 = @applications.first
    @application2 = @applications.second
    @test_user.switch_applications(@application1, @application2)
    expect(@application2.reload.priority).to eq 1
    expect(@application1.reload.priority).to eq 2
  end

  it "can be assigned to only one course in a block"
    #create user with batch
    #create result for a course in a block
    #create result for another course in that block
    #it should fail


    context "csv export" do
      subject { FactoryGirl.create_list(:user, 5) }

      it { should respond_to(:to_csv) }

      it "should generate correct nuber of rows" do
        @csv = CSV.parse(User.to_csv, {col_sep: ';'})
        expect(@csv.length).to eq User.count + 1
      end

      it "should generate correct headers" do
        @csv = CSV.parse(User.to_csv, {col_sep: ';'})
        expect(@csv.first).to eq ["id","Email","Name","RUT","Password","Course_Batch"]
      end

      it "should generate correct data" do
        @csv = CSV.parse(User.to_csv, {col_sep: ';'})
        expect(@csv[1]).to eq [@user.id.to_s, @user.email.to_s, @user.name.to_s, @user.rut.to_s, nil, @user.course_batch_id ,nil]
      end


    end

end