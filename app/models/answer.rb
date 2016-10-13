class Answer < ActiveRecord::Base
  belongs_to :rating
  belongs_to :option
end
