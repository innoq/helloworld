class Status < ActiveRecord::Base

  belongs_to :profile

  validates :message, :presence => true, :length => { :minimum => 5 }

end
