class CourseBatch < ActiveRecord::Base
  has_one :student

  validates :name, presence: true

  after_initialize :set_default_status, :if => :new_record?

  def set_default_status
    self.open_status = true
  end


end
