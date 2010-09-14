source 'http://rubygems.org'

gem 'rails', '3.0.0'

platforms :jruby do
  gem 'activerecord-jdbcsqlite3-adapter'
end
platforms :ruby do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :development do
  gem 'mongrel'
end

gem 'forgery'
gem 'will_paginate', "~>3.0.pre2"
