class Application < ActiveRecord::Base
  validates :priority, presence: true
  belongs_to :user
  belongs_to :course

  # def to_csv
  #   csv = []
  #   csv += [:updated_at, :student_id, :course_id, :priority].map { |f| self[f] }
  # end

  def self.to_csv
    CSV.generate(col_sep:";") do |csv|
      csv << ["Timestamp", "Student ID", "Course ID", "Priority"]
      all.each do |application|
        csv << [:updated_at, :user_id, :course_id, :priority,"\n"].map { |f| application[f] unless f == "\n"}
      end
    end
  end

end
