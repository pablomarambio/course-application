describe Application do

  before(:each) { @application = FactoryGirl.create :application }

  subject { @application }

  it { should respond_to(:priority) }

  it {should validate_presence_of :priority}

  it {should belong_to :user}
  it {should belong_to :course}


  context "csv export" do
    subject { FactoryGirl.create_list(:application, 5) }

    it { should respond_to(:to_csv) }

    it "should generate correct nuber of rows" do
      @csv = CSV.parse(Application.to_csv, {col_sep: ';'})
      expect(@csv.length).to eq Application.count + 1
    end

    it "should generate correct headers" do
      @csv = CSV.parse(Application.to_csv, {col_sep: ';'})
      expect(@csv.first).to eq ["Timestamp", "Student ID", "Course ID", "Priority"]
    end

    it "should generate correct data" do
      @csv = CSV.parse(Application.to_csv, {col_sep: ';'})
      expect(@csv[1]).to eq [@application.updated_at.to_s, @application.user_id.to_s, @application.course_id.to_s, @application.priority.to_s, nil]
    end


  end


end