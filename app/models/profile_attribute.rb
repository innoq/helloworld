class ProfileAttribute < ActiveRecord::Base
  def self.types 
    %w(company_email private_email company_phone mobile_phone private_phone)
  end
end
