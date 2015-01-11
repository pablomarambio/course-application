class Course < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :classroom, presence: true
  validates :capacity, presence: true

  belongs_to :block
  belongs_to :course_batch

  has_many :applications, dependent: :destroy
  has_many :results, dependent: :destroy

  def self.to_csv
    CSV.generate(col_sep:";") do |csv|
      csv << ["id","Name","Batch","Block","From","To","Classroom","Capacity"]
      all.each do |course|
        csv << [course.id, course.name, course.course_batch_id, course.block_id, course.block.try(:from).try(:strftime,"%H:%M"),course.block.try(:to).try(:strftime,"%H:%M"), course.classroom, course.capacity]
      end
    end
  end

end