class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :block
end
