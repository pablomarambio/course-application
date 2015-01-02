class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  validates :rut, uniqueness: true, presence: true, numericality: true
  validates :name, presence: true

  belongs_to :course_batch
  has_many :applications
  has_many :results

  attr_accessor :login

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

 def set_default_role
   self.role ||= :user
 end

 def courses
    courses = []
    unless course_batch.nil?
      course_batch.blocks.each do |block|
        block.courses.each{|course| courses << course}
      end
    end
    courses
 end

 def self.with_completed_applications
    User.all.select{|user| user.courses.count > 0 }.select{|user| user.applications.count == user.courses.count}
 end

 def self.with_incompleted_applications
    User.all.select{|user| user.courses.count >0}.select{|user| user.applications.count < user.courses.count}
 end

 def self.idle
    User.all.select{|user| user.applications.count == 0}
 end

 def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(rut) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
end

def self.to_csv
  CSV.generate(col_sep:";") do |csv|
    csv << ["id","Email","Name","RUT","Password","Course_Batch"]
    all.each do |user|
      csv << [:id, :email, :name, :rut,:password,:course_batch_id,"\n"].map { |f| user[f] unless f == "\n"}
    end
  end
end

def applications_for_block(block)
  @applications = []

  block.courses.each do |course|

    @application = Application.where(user_id: self.id, course_id: course.id).first
    if @application
      @applications << @application
    else
      @applications << Application.create(user_id: self.id, course_id: course.id, priority: @applications.count+1)
    end

    @applications.sort!{|a,b| a.priority <=> b.priority}

    # @applications.each do |application|
    #   application.priority = @applications.index(application)+1
    #   application.save
    # end
  end
  @applications

end

def switch_applications(application1, application2)
  priority1 = application1.priority
  priority2 = application2.priority
  application1.priority = priority2
  application2.priority = priority1
  application1.save
  application2.save
end

end