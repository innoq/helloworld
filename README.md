## Sample App, more to follow, not yet useful for anything

### Setup

Clone Helloworld:

    git clone git@github.com:innoq/helloworld.git

Bundle dependencies:

    bundle install

Create and initialize Database

    bundle exec rake db:setup

Popoulate some data:

    bundle exec rake db:populate

Run the server:

    rails server

### Deployment

   bundle exec cap innoq deploy

### TODO

* Status
* Layout & CSS
  * Dashboard
  * Forms

#### Later:

* Messages

### Heroku

Add S3 config to Heroku:

   heroku config:add S3_BUCKET=helloworld_uploads S3_KEY=XXX S3_SECRET=XXX
