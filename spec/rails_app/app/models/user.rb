class User < ActiveRecord::Base
  has_many :some_resources

  has_many :collaborated_events,
    through: :collaborations,
    source: :user
  has_many :collaborations

end
