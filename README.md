## Sample App, more to follow, not yet useful for anything

### Setup

Install rails:
    gem install rails

Clone Helloworld:
    git clone git@github.com:innoq/helloworld.git

Bundle dependencies:
    bundle install

Create and Initialize Database
    rake db:setup

Popoulate some Data:
    rake db:populate

Run the server:
    rails s

### TODO
* Status
* Layout & CSS
  * Dashboard
  * Forms

#### Later:
* Messages

### Heroku
Add S3 config to heroku:
   heroku config:add S3_BUCKET=helloworld_uploads S3_KEY=XXX S3_SECRET=XXX