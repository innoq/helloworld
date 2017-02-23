class Status < ActiveRecord::Base

  attr_accessible :message, :created_at, :updated_at

  belongs_to :profile

  validates :message, :presence => true, :length => { :minimum => 2 }

end
