class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :private_address, :class_name => 'Address'
  belongs_to :business_address, :class_name => 'Address'
  has_many :profile_attributes
  has_many :relations, :foreign_key => :source_id
  has_many :contacts, :through => :relations, :source => :destination
  has_many :sent_messages, :foreign_key => :from_id, :class_name => "Message"
  has_many :received_messages, :foreign_key => :to_id, :class_name => "Message"

  def full_name 
    "#{first_name} #{last_name}"
  end

  def contact_count 
    # intentionally stupid
    contacts.count
  end
end
