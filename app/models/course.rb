class Course < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :classroom, presence: true
  validates :capacity, presence: true

  belongs_to :block
  belongs_to :course_batch

  has_many :applications, dependent: :destroy
  has_many :results, dependent: :destroy

end