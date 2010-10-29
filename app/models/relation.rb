class Relation < ActiveRecord::Base
  belongs_to :source, :class_name => "Profile"
  belongs_to :destination, :class_name => "Profile"

  scope :accepted, where(:accepted => true)

  scope :not_accepted, where(:accepted => false)

end
