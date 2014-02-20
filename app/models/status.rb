class Status < ActiveRecord::Base

  attr_accessible :message

  belongs_to :profile

  validates :message, :presence => true, :length => { :minimum => 5 }

end
