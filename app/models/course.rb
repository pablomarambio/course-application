class Course < ActiveRecord::Base

  validates :name, presence: true
  validates :classroom, presence: true
  validates :capacity, presence: true

  belongs_to :block

end