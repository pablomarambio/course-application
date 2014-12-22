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

  context "csv export" do
    subject { FactoryGirl.create_list(:course, 5) }

    it { should respond_to(:to_csv) }

    it "should generate correct nuber of rows" do
      @csv = CSV.parse(Course.to_csv, {col_sep: ';'})
      expect(@csv.length).to eq Course.count + 1
    end

    it "should generate correct headers" do
      @csv = CSV.parse(Course.to_csv, {col_sep: ';'})
      expect(@csv.first).to eq ["ID","Name","Batch","Block","From","To","Classroom","Capacity"]
    end

    it "should generate correct data" do
      @block = FactoryGirl.create :block_with_courses
      @block.courses << @course
      @csv = CSV.parse(Course.to_csv, {col_sep: ';'})
      expect(@csv[1]).to eq [@course.id.to_s, @course.name.to_s, @course.course_batch_id.to_s, @course.block_id.to_s, @course.block.from.to_s, @course.block.to.to_s,  @course.classroom.to_s , @course.capacity.to_s,"\n"]
    end


  end


end