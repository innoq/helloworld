source 'http://rubygems.org'

gem 'rails', '~>3.2'

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
end
platforms :ruby do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

gem 'aws-s3'

gem 'forgery'
gem 'will_paginate', "~>3.0.pre2"
gem 'ya2yaml'

gem 'paperclip', '~> 2.3.4'

gem 'cancan'

group 'development' do
  gem 'capistrano'
end
