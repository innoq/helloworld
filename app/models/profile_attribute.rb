class ProfileAttribute < ActiveRecord::Base

  attr_accessible :attr_type, :value, :profile, :profile_id

  def self.types
    %w(company_email private_email company_phone mobile_phone private_phone)
  end
end
