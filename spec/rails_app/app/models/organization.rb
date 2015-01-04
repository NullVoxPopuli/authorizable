class Organization < ActiveRecord::Base
  belongs_to :owner, class_name: "User"
  belongs_to :user, foreign_key: :owner_id

  has_many :collaborations, as: :collaborated
  has_many :collaborators, through: :collaborations, source: :user

  alias_attribute :user_id, :owner_id

end