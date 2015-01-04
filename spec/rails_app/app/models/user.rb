class User < ActiveRecord::Base
  has_many :some_resources

  has_many :collaborated_some_resources,
    through: :collaborations,
    source: :collaborated,
    source_type: Event.name
  has_many :collaborations

end
