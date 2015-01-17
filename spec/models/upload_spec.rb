describe Upload do

  before(:each) { @upload = FactoryGirl.create(:upload, :users)}

  subject { @upload }

  it { should respond_to(:upload_type) }
  it { should respond_to(:file) }
  it { should respond_to(:rows)}
  it {should respond_to(:read_rows)}
  it {should respond_to(:process_row)}

  it {should validate_presence_of :upload_type}
  it {should validate_presence_of :file}


  context "of users" do

    before do
      @users_upload = FactoryGirl.create(:upload, :users)
      @course_batch = FactoryGirl.create(:course_batch, :with_blocks, name: "basica")
    end

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
      expect(@test_user.course_batch.name).to eq "basica"
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
      expect(@test_user.reload.course_batch.name).to eq "basica"
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

  context "users with bad column headers" do
    before { @bad_users = FactoryGirl.build(:upload, :users_with_missing_columns) }

    subject {@bad_users }

    it "should not be valid" do
      expect(subject.valid?).to be false
    end

    it "should have error message about missing columns on file field" do
      subject.save
      expect(subject.errors[:file]).to include " has incorrect headers. It should contain: #{Upload::USER_HEADERS.join(', ')}, uploaded file has: id, Email, RUT, Password"
    end
  end

  context "users with blanks" do

    before {@users_with_blanks = FactoryGirl.create(:upload, :users_with_blanks)}

    subject {@users_with_blanks}

    it "should reject rows with no values" do
      expect(subject.rows.count).to eq 6
    end




  end

  context "courses" do

    before (:each) { @courses_upload = FactoryGirl.create(:upload, :courses)}

    subject {@courses_upload}

    it "should read CSV file and split it into rows" do
      expect(subject.rows.count).to eq 9
    end

    it "should create course from CSV row without id and find/update or create batch and block" do
      #Creates the course "Maths". If the batch "elementary" doesn't exist, it creates it. If the block "morning" doesn't exist,
      # it creates it and it assigns it from=10:00, to=11:30. It then assigns the block to the batch if it wasn't assigned to it already.
      #It then assigns the course to the block.
      subject.process_row(1)
      expect(subject.upload_results[0].message).to eq "Course created"
      expect(subject.upload_results[0].result_type).to eq "Success"
      @test_course= Course.last
      expect(@test_course.nil?).to eq false
      expect(@test_course.name).to eq "Maths"
      expect(@test_course.block.name).to eq "morning"
      expect(@test_course.block.to).to eq "2000-01-01 11:30:00.000000000 +0000"
      expect(@test_course.block.from).to eq "2000-01-01 10:00:00.000000000 +0000"
      expect(@test_course.course_batch.name).to eq "elementary"
      expect(@test_course.classroom).to eq "2"
      expect(@test_course.capacity).to eq 23
      expect(@test_course.course_batch.blocks).to include @test_course.block
    end

    it "should create course and assign it to the block" do
      #Creates the course "Kitchen physiscs". It then assigns the course to the block "morning"
      subject.process_row(2)
      expect(subject.upload_results[0].message).to eq "Course created"
      expect(subject.upload_results[0].result_type).to eq "Success"
      @test_course= Course.last
      expect(@test_course.nil?).to eq false
      expect(@test_course.name).to eq "Kitchen physiscs"
      expect(@test_course.block.name).to eq "morning"
      expect(@test_course.block.to).to eq "2000-01-01 11:30:00.000000000 +0000"
      expect(@test_course.block.from).to eq "2000-01-01 10:00:00.000000000 +0000"
      expect(@test_course.course_batch.name).to eq "elementary"
      expect(@test_course.classroom).to eq "3"
      expect(@test_course.capacity).to eq 42
      expect(@test_course.course_batch.blocks).to include @test_course.block
    end

    it "should create course and assign it to the block" do
      #Creates the course "Videogame programming".
      #If the block "afternoon" doesn't exist, it creates it and it assigns it from=15:00, to=16:30.
      #It then assigns the block to the batch if it wasn't assigned to it already.
      #It then assigns the course to the block "afternoon".
      subject.process_row(3)
      expect(subject.upload_results[0].message).to eq "Course created"
      expect(subject.upload_results[0].result_type).to eq "Success"
      @test_course= Course.last
      expect(@test_course.nil?).to eq false
      expect(@test_course.name).to eq "Videogame programming"
      expect(@test_course.block.name).to eq "afternoon"
      expect(@test_course.block.to).to eq "2000-01-01 16:30:00.000000000 +0000"
      expect(@test_course.block.from).to eq "2000-01-01 15:00:00.000000000 +0000"
      expect(@test_course.course_batch.name).to eq "elementary"
      expect(@test_course.classroom).to eq "4"
      expect(@test_course.capacity).to eq 23
      expect(@test_course.course_batch.blocks).to include @test_course.block
    end

    it "should update course from CSV row with id" do
      #It updates Course ID=222, assigning it a new name: "How to poo".
      #It then creates batch and block if they didn't exist before.
      #If the block existed, it is assigned a new "from" and "to" time.
      #The it assigns the block to the batch if it wasn't already assigned,
      #and the course to the block if it wasn't already assigned.
      @test_course = FactoryGirl.create(:course, id: 222, name: "CHANGEME")
      @test_block = FactoryGirl.create(:block_with_courses, name: "early hours")
      subject.process_row(4)
      expect(@test_course.reload.name).to eq "How to poo"
      expect(@test_course.reload.block.name).to eq "early hours"
      expect(@test_course.reload.block.to).to eq "2000-01-01 07:30:00.000000000 +0000"
      expect(@test_course.reload.block.from).to eq "2000-01-01 06:00:00.000000000 +0000"
      expect(@test_course.reload.course_batch.blocks).to include @test_course.block
    end

    it "should delete course from CSV row with only id and its applications and results" do
      @test_course = FactoryGirl.create(:course, id: 223)
      @test_course.applications << FactoryGirl.create_list(:application, 3)
      @test_course.results << FactoryGirl.create_list(:result, 3)
      subject.process_row(5)
      expect(Course.where(id:223).blank?).to eq true
      expect(Application.count).to eq 0
      expect(Result.count).to eq 0
    end



    #Error: cannot update because block and batch are blank.
    it "should return error when batch name is blank" do
      @test_course = FactoryGirl.create(:course, id: 224, name: "CHANGEME")
      subject.process_row(6)
      expect(@test_course.reload.name).to eq "CHANGEME"
      expect(subject.upload_results[0].message).to eq "Blocks is invalid and Name can't be blank"
      expect(subject.upload_results[0].result_type).to eq "Error"
    end

    #Error: cannot update because block is blank.
    it "should return error when block name is blank" do
      @test_course = FactoryGirl.create(:course, id: 225, name: "CHANGEME")
      subject.process_row(7)
      expect(@test_course.reload.name).to eq "CHANGEME"
      expect(subject.upload_results[0].message).to eq "Blocks is invalid"
      expect(subject.upload_results[0].result_type).to eq "Error"
    end

    #Error: cannot create because course name is blank
    it "should return error when course name is blank" do
      subject.process_row(8)
      expect(subject.upload_results[0].message).to eq "Name can't be blank, Classroom can't be blank, and Capacity can't be blank"
      expect(subject.upload_results[0].result_type).to eq "Error"
    end

    #Error: cannot create because course name is already taken
    it "should return error when course name is taken" do
      @test_course = FactoryGirl.create(:course, name: "Videogame programming")
      subject.process_row(9)
      expect(subject.upload_results[0].message).to eq "Name has already been taken"
      expect(subject.upload_results[0].result_type).to eq "Error"
    end

  end

  context "courses with bad column headers" do
    before { @bad_courses = FactoryGirl.build(:upload, :courses_with_missing_columns) }

    subject {@bad_courses }

    it "should not be valid" do
      expect(subject.valid?).to be false
    end

    it "should have error message about missing columns on file field" do
      subject.save
      expect(subject.errors[:file]).to include " has incorrect headers. It should contain: #{Upload::COURSE_HEADERS.join(', ')}, uploaded file has: id, Name, Block, From, To, Capacity"
    end

  end

  context "results" do

    before (:each) { @results_upload = FactoryGirl.create(:upload, :results)}

    subject {@results_upload}

    it "should read CSV file and split it into rows" do
      expect(subject.rows.count).to eq 7
    end

    it "should return error for row with non-existent RUT" do
      subject.process_row(1)
      expect(subject.upload_results[0].message).to eq "Student not found"
      expect(subject.upload_results[0].result_type).to eq "Error"
    end

    it "should return error for a row with bad block" do
      @block = FactoryGirl.build(:block, name: "morning")
      @course = FactoryGirl.create(:course, name: "English", block_id: @block.id)
      @block.courses << @course
      @block.save
      @student = FactoryGirl.create(:user, :completed_application, rut: "14569484")
      @student.applications << Application.create(user_id: @student.id, course_id: @course.id, priority: 1)
      subject.process_row(2)
      expect(subject.upload_results[0].message).to eq "Block not found"
      expect(subject.upload_results[0].result_type).to eq "Error"
      expect(@student.results.count).to eq 0
    end

    it "should return error for a row with bad course" do
      @block = FactoryGirl.build(:block, name: "morning")
      @course = FactoryGirl.create(:course, name: "English", block_id: @block.id)
      @block.courses << @course
      @block.save
      @student = FactoryGirl.create(:user, :completed_application, rut: "14569484")
      @student.applications << Application.create(user_id: @student.id, course_id: @course.id, priority: 1)
      subject.process_row(3)
      expect(subject.upload_results[0].message).to eq "Course not found"
      expect(subject.upload_results[0].result_type).to eq "Error"
      expect(@student.results.count).to eq 0
    end

    it "should update course in application when result already exists"  do
      @block = FactoryGirl.build(:block, name: "morning")
      @course = FactoryGirl.create(:course, name: "English", block_id: @block.id)
      @course2 = FactoryGirl.create(:course, name: "Literature", block_id: @block.id)
      @block.courses << @course
      @block.courses << @course2
      @block.save
      @student = FactoryGirl.create(:user, :completed_application, rut: "8457638")
      @student.applications << Application.create(user_id: @student.id, course_id: @course.id, priority: 1)
      @student.applications << Application.create(user_id: @student.id, course_id: @course2.id, priority: 2)
      @student.results << Result.create(user_id: @student.id, course_id:@course.id, block_id: @block.id)
      subject.process_row(5)
      expect(subject.upload_results[0].message).to eq "Result updated"
      expect(subject.upload_results[0].result_type).to eq "Success"
      expect(@student.results.count).to eq 1
      expect(@student.results.first.user_id).to eq @student.id
      expect(@student.results.first.course.name).to eq "Literature"
      expect(@student.results.first.block.name).to eq "morning"
    end

    it "should create a result from a correct row"do
      @block = FactoryGirl.build(:block, name: "morning")
      @course = FactoryGirl.create(:course, name: "English", block_id: @block.id)
      @block.courses << @course
      @block.save
      @student = FactoryGirl.create(:user, :completed_application, rut: "8457638")
      @student.applications << Application.create(user_id: @student.id, course_id: @course.id, priority: 1)
      subject.process_row(4)
      expect(subject.upload_results[0].message).to eq "Result created"
      expect(subject.upload_results[0].result_type).to eq "Success"
      expect(@student.results.count).to eq 1
      expect(@student.results.first.user_id).to eq @student.id
      expect(@student.reload.results.first.course.name).to eq "English"
      expect(@student.results.first.block.name).to eq "morning"
    end

    it "should delete all results for a student from a row with only ID" do
      @student = FactoryGirl.create(:user, :completed_application, rut: "21231231")
      @student2 = FactoryGirl.create(:user, :completed_application, rut: "123569484")
      subject.process_row(6)
      expect(@student.applications.count).to eq 0
      expect(@student2.applications.count).to eq 9
      expect(subject.upload_results[0].message).to eq "All applications for user have been deleted"
      expect(subject.upload_results[0].result_type).to eq "Success"
    end

    it "should show error when trying to delete results for student with non existing RUT" do
      @student = FactoryGirl.create(:user, :completed_application, rut: "14569484")
      subject.process_row(7)
      expect(@student.applications.count).to eq 9
      expect(subject.upload_results[0].message).to eq "Student not found"
      expect(subject.upload_results[0].result_type).to eq "Error"
    end
  end

  context "results  with bad column headers" do
    before { @bad_results = FactoryGirl.build(:upload, :results_with_missing_columns) }

    subject {@bad_results }

    it "should not be valid" do
      expect(subject.valid?).to be false
    end

    it "should have error message about missing columns on file field" do
      subject.save
      expect(subject.errors[:file]).to include " has incorrect headers. It should contain: #{Upload::RESULT_HEADERS.join(', ')}, uploaded file has: RUT, Block"
    end

  end

end
