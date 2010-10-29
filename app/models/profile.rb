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

  accepts_nested_attributes_for :profile_attributes, :private_address, :business_address, :allow_destroy => true

  validates :last_name, :presence => true
  validates :company, :presence => true

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

  # Forces private_address and business_address to hold an Address (which will
  # be unsaved if none exsited before)
  def ensure_addresses
    self.private_address ||= Address.new
    self.business_address ||= Address.new
  end

  # Forces :profile_attributes to hold a (possibly unsaved) ProfileAttribute of
  # every attr_type
  def ensure_all_profile_attributes
    (ProfileAttribute.types - self.profile_attributes.all.map(&:attr_type)).each do |missing_pt|
      self.profile_attributes.build(:attr_type => missing_pt)
    end
  end

  ProfileAttribute.types.each do |m|
    define_method m do
      profile_attributes.find_by_attr_type(m)
    end
  end

  def self.search(word)
    where(arel_table[:last_name].matches(word).or(arel_table[:first_name].matches(word))).
      select(:id).
      map(&:id)
  end

end
