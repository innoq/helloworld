class Profile < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :profession, :company, :about, :created_at, :updated_at
  attr_accessible :private_address, :private_address_id, :business_address, :business_address_id, :photo

  belongs_to :user
  belongs_to :private_address, :class_name => 'Address', :dependent => :destroy
  belongs_to :business_address, :class_name => 'Address', :dependent => :destroy

  has_many :profile_attributes, :dependent => :destroy

  has_many :relations, :foreign_key => :source_id, :dependent => :destroy
  has_many :incoming_relations, :foreign_key => :destination_id, :class_name => "Relation", :dependent => :destroy

  has_many :sent_messages, :foreign_key => :from_id, :class_name => "Message", :dependent => :destroy
  has_many :received_messages, :foreign_key => :to_id, :class_name => "Message", :dependent => :destroy

  has_many :statuses, :dependent => :destroy

  accepts_nested_attributes_for :profile_attributes, :private_address, :business_address, :allow_destroy => true

  validates :last_name, :presence => true
  validates :company, :presence => true

  paperclip_options = {
    :default_url => "/assets/missing.png"
  }
  if ENV['S3_BUCKET']
    paperclip_options.merge!(
      :storage => :s3,
      :s3_credentials => {
        :access_key_id => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']
      },
      :bucket => ENV['S3_BUCKET'],
      :path => ":attachment/:id.:extension"
    )
  else
    paperclip_options.merge!(
      :url => "/system/:attachment/:id.:extension",
      :path => ":rails_root/public/system/:attachment/:id.:extension"
    )
  end

  has_attached_file :photo, paperclip_options

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
    where(["LOWER(#{self.table_name}.last_name) like :word OR LOWER(#{self.table_name}.first_name) like :word OR LOWER(#{self.table_name}.company) like :word", {:word => word.downcase}]).
        select(:id).
        map(&:id)
  end

end
