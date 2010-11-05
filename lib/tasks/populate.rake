PROFILE_COUNT = (ENV['USERS'] || 129).to_i
RELATION_COUNT = (ENV['RELATIONS']|| 10).to_i
MESSAGE_COUNT = (ENV['MESSAGES'] || 3).to_i
STATUS_COUNT = (ENV['STATUS'] || 10).to_i

def rand_time(days = 365)
  rand(days).days.ago - rand(24).hours - rand(60).minutes
end

def rand_profession
  %w(CEO CFO CIO Entrepreneur Developer Assistant Manager Accountant Photographer).random
end

def random_boolean
  [false, true].random
end

def maybe(&block)
  yield if random_boolean
end

def photo_file_names
  @photo_file_names ||= Dir.glob(Rails.root.join('data/photos/*.{png,jpg,gif}'))
end

def rand_type 
  ProfileAttribute.types.random
end

def random_profile
  Profile.find(:first, :offset => rand(PROFILE_COUNT))
end

def random_set(count, limit)
  a = Set.new
  a.add(rand(limit)) until a.count == count  
  a
end

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
  speakers = YAML.load(File.open(Rails.root.join("data/speaker.yml")))

  Profile.delete_all
  User.delete_all
  Address.delete_all
  i=0
  PROFILE_COUNT.times do
    if i <  speakers.length
      data = speakers[i].symbolize_keys
    else
      data[:first_name] = Forgery::Name.first_name
      data[:last_name] = Forgery::Name.last_name
      data[:file] = photo_file_names[i % photo_file_names.count]  
    end
    data[:company] = Forgery::Name.company_name if data[:company].blank?

    p = Profile.create! :last_name => data[:last_name],
      :first_name => data[:first_name],
      :company => data[:company],
      :profession => rand_profession,
      :about => Forgery::LoremIpsum.paragraph,
      :created_at => rand_time,
      :updated_at => rand_time
    p.create_user :login => data[:first_name][0,1].downcase + data[:last_name].camelcase.downcase,
      :password  => Forgery::Basic.password,
      :created_at => rand_time,
      :updated_at => rand_time

    p.photo = File.new(data[:file])

    maybe { p.private_address = create_address }
    maybe { p.business_address = create_address }
    p.profile_attributes << create_profile_attributes
    p.save!
    i += 1
  end
end

def random_connections(count, &block) 
  PROFILE_COUNT.times do
    source = random_profile
    random_set(rand(count), PROFILE_COUNT).each do |offset|
      target = Profile.find(:first, :offset => offset)
      yield source, target unless source == target
    end
  end
end 

def create_relations
  Relation.delete_all
  random_connections(RELATION_COUNT) do |source, target|
    Relation.create! :source => source, :destination => target,
      :comment => Forgery::LoremIpsum.paragraph,
      :accepted => true,
      :created_at => rand_time,
      :updated_at => rand_time
    Relation.create! :source => target, :destination => source,
      :comment => Forgery::LoremIpsum.paragraph,
      :accepted => random_boolean,
      :created_at => rand_time,
      :updated_at => rand_time 
  end
end

def create_messages
  Message.delete_all
  random_connections(MESSAGE_COUNT) do |source, target|
    Message.create! :from => source, :to => target, 
      :subject => Forgery::LoremIpsum.sentence,
      :body => Forgery::LoremIpsum.paragraph,
      :created_at => rand_time,
      :updated_at => rand_time
  end
end

def create_statuses
  Status.delete_all
  STATUS_COUNT.times do
    who = random_profile
    Status.create! :profile => who,
      :message => Forgery::LoremIpsum.sentence,
      :created_at => rand_time
  end
end

begin
  namespace :db do
    desc "Populate the development database with some fake data, based on #{PROFILE_COUNT} users"
    task :populate => :environment do
      create_profiles
      create_statuses
      create_relations
      create_messages
    end
  end
rescue LoadError
  puts "Please run 'sudo gem install forgery' before executing this task"
end


