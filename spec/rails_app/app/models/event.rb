class Event < ActiveRecord::Base
  belongs_to :user
  has_many :collaborations, as: :collaborated
  has_many :collaborators, through: :collaborations, source: :user
end
