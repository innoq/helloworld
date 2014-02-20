class Message < ActiveRecord::Base

  attr_accessible :subject, :body, :to, :to_id

  belongs_to :from, :class_name => "Profile"
  belongs_to :to, :class_name => "Profile"

end
