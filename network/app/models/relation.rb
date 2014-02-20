class Relation < ActiveRecord::Base

  attr_accessible :destination_id, :destination, :comment, :accepted

  belongs_to :source, :class_name => "Profile"
  belongs_to :destination, :class_name => "Profile"

  scope :accepted, where(:accepted => true)

  scope :not_accepted, where(:accepted => false)

end
