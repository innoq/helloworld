require 'rubygems'

# oracle loves you if you do your language setup properly
ENV['NLS_LANG'] = 'AMERICAN_AMERICA.AL32UTF8'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
