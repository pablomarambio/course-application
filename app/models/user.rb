class User < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  validates :rut, uniqueness: true, presence: true, numericality: true
  validates :name, presence: true

  belongs_to :course_batch

  def set_default_role
    self.role ||= :user
  end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
