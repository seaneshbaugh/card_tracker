# Card Tracker

## Ruby Version

This application is intended to be run on Ruby 1.8.7-p173. Due to limitations of my current host Ruby 1.9+ is not directly supported.

## Rails Version

This application uses Rails 3.2.17

## Required Gems

The following gems are required to run this application:

* rails (3.2.17)
* mysql2
* cancan
* daemons
* delayed_job
* delayed_job_active_record
* devise (3.1.2)
* exception_notification (~> 3.0.1)
* honeypot-captcha
* kaminari (0.14.1)
* ransack
* sanitize (2.0.3)
* simple_form
* yaml_db
* jquery-rails
* jquery-ui-rails
* less-rails
* less-rails-bootstrap
* therubyracer
* uglifier
* capistrano (~> 2.15.5)
* capistrano-ext
* mailcatcher
* quiet_assets

## Local Development Installation

Clone the repository.

    $ git clone git@github.com:seaneshbaugh/card_tracker.git card_tracker

cd into the project directory. If you don't have ruby-1.8.7-p173 already you will want to install it before doing this.

    $ cd portfolio

Install the necessary gems.

    $ bundle install

Create the databases.

    $ rake db:create

Add the database tables.

    $ rake db:migrate
    $ RAILS_ENV=test rake db:migrate

Seed the database.

    $ rake db:seed

## Contacts

* [Sean Eshbaugh](mailto:seaneshbaugh@gmail.com)
