# Helpers
def rand_time(days = 365)
  rand(days).days.ago - rand(24).hours - rand(60).minutes
end

def random_profile
  @profile_count ||= Profile.count
  Profile.offset(rand(@profile_count)).first
end

# Test Factories

def create_profile_attributes
  attrs = []
  attrs << (ProfileAttribute.new :attr_type => "company_email",
    :value => Forgery::Internet.email_address)
  attrs << (ProfileAttribute.new :attr_type => "private_email",
    :value => Forgery::Internet.email_address)
  attrs << (ProfileAttribute.new :attr_type => "company_phone",
    :value => Forgery(:address).phone)
  attrs << (ProfileAttribute.new :attr_type => "mobile_phone",
    :value => Forgery(:address).phone)
  attrs << (ProfileAttribute.new :attr_type => "private_phone",
    :value => Forgery(:address).phone)

  attrs
end

def create_address
  Address.create!  :street => Forgery::Address.street_address,
      :city => Forgery::Address.city,
      :zip => Forgery::Address.zip,
      :country => Forgery::Address.country
end

def create_profiles
  ['male', 'female'].each do |gender|
    data = {}
    Dir.glob(Rails.root.join("data/photos/pexels/#{gender}/*.{png,jpg,jpeg,gif}")).each do |photo_file|
      data[:first_name] = Forgery::Name.send("#{gender}_first_name")
      data[:last_name] = Forgery::Name.last_name
      data[:file] = photo_file
      data[:profession] = Forgery::Name.job_title
      data[:company] = Forgery::Name.company_name

      puts "#{data[:first_name]} #{data[:last_name]}"

      p = Profile.create! :last_name => data[:last_name],
          :first_name => data[:first_name],
          :company => data[:company],
          :profession => data[:profession],
          :about => Forgery::LoremIpsum.paragraph,
          :created_at => rand_time,
          :updated_at => rand_time
      p.create_user :login => data[:first_name][0,1].downcase + data[:last_name].camelcase.downcase,
          :password  => Forgery::Basic.password

      p.photo = File.new(data[:file])

      p.private_address = create_address
      p.business_address = create_address
      p.profile_attributes << create_profile_attributes
      p.save!
    end
  end
end

def create_relations
  Profile.all.each do |source|
    (rand(5) + 5).times do
      target = random_profile
      source.relations.create! :destination => target,
          :comment => Forgery::LoremIpsum.paragraph,
          :accepted => true
      target.relations.create! :destination => source,
          :comment => Forgery::LoremIpsum.paragraph,
          :accepted => rand > 0.3
    end
  end
end

def create_statuses
  Profile.all.each do |source|
    rand(5).times do
      source.statuses.create! :message => Forgery::LoremIpsum.sentence,
          :created_at => rand_time
    end
  end
end

# Task

namespace :db do
  desc "Populate the development database with some fake data, based on availiable images in data/photos/pexles"
  task :populate_pexels => :environment do
    if (ENV['DESTROY'])
      puts "** Destroying everything"
      Profile.destroy_all
      User.destroy_all
    end
    puts "** Creating profiles"
    create_profiles
    puts "** Creating statuses"
    create_statuses
    puts "** Creating relations"
    create_relations
  end

end

