class CourseBatch < ActiveRecord::Base
  has_many :users
  has_many :blocks

  validates :name, presence: true
  validate :validate_blocks_count


  after_initialize :set_default_status, :if => :new_record?


  def set_default_status
    self.open_status = true
  end

  def validate_blocks_count
    errors.add(:blocks, "count must be at least one.") if blocks.size < 1
  end

  def courses
    blocks.collect{|b| b.courses}.flatten
  end


end