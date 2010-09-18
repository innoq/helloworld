class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :private_address, :class_name => 'Address'
  belongs_to :business_address, :class_name => 'Address'
  has_many :profile_attributes
  has_many :relations, :foreign_key => :source_id
  has_many :contacts, :through => :relations, :source => :destination
  has_many :sent_messages, :foreign_key => :from_id, :class_name => "Message"
  has_many :received_messages, :foreign_key => :to_id, :class_name => "Message"
  has_many :statuses

  def full_name 
    "#{first_name} #{last_name}"
  end

  def contact_count 
    # intentionally stupid
    contacts.count
  end

  def message_count
    received_messages.count
  end

  def image
    "user.png"
  end

  %w(company_email private_email company_phone mobile_phone private_phone).each do |m|
    define_method m do
      profile_attributes.find_by_attr_type(m)
    end
  end

end
