class Application < ActiveRecord::Base
  validates :priority, presence: true
  belongs_to :user
  belongs_to :course
end
