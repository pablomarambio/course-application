class Block < ActiveRecord::Base


  validates :name, presence: true
  validates :to, presence: true
  validates :from,presence: true

  belongs_to :course_batch
  has_many :courses

  validate :validate_courses_count

  delegate :open_status, to: :course_batch

  def validate_courses_count
    errors.add(:courses, "count must be at least one.") if courses.size < 1
  end



end
