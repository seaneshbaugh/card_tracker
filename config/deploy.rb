set :stages, %w(production)
set :default_stage, 'production'

require 'bundler/capistrano'
require 'delayed/recipes'
require 'capistrano/ext/multistage'

load 'config/recipes/base'
load 'config/recipes/check'
load 'config/recipes/db'
load 'config/recipes/mysql'
load 'config/recipes/smtp'
load 'config/recipes/secret'
load 'config/recipes/devise'
load 'config/recipes/uploads'

set :application, 'card_tracker'
set :user, 'cavesofk'
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, 'git'
set :repository, 'git@github.com:seaneshbaugh/card_tracker.git'
set :scm_verbose, true
set :bundle_flags, '--deployment'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy',         'deploy:cleanup'
after 'deploy:stop',    'delayed_job:stop'
after 'deploy:start',   'delayed_job:start'
after 'deploy:restart', 'delayed_job:restart'

load 'deploy/assets'

namespace :deploy do
  namespace :assets do
    desc 'Run the precompile task locally and rsync with shared'
    task :precompile, :roles => :web, :except => { :no_release => true } do
      %x{bundle exec rake assets:precompile}
      %x{rsync --recursive --times --rsh=ssh --compress --human-readable --progress public/assets #{user}@#{domain}:#{shared_path}}
      %x{bundle exec rake assets:clean}
    end
  end
end
