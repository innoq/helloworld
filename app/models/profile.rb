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

  has_attached_file :photo,
    :default_url => "/images/:attachment/missing_:style.png",
    :url => "/system/:attachment/:id/:style.:extension",
    :path => ":rails_root/public/system/:attachment/:id/:style.:extension",
    :styles => {:small => "61x61#", :medium => "113x108#", :normal => "231x290#"}

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

  %w(company_email private_email company_phone mobile_phone private_phone).each do |m|
    define_method m do
      profile_attributes.find_by_attr_type(m)
    end
  end

end
