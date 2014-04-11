require 'securerandom'

namespace :secret do
  desc 'Generate the secret.yml configuration file.'
  task :setup, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    template 'secret.yml.erb', "#{shared_path}/config/secret.yml"
  end
  after 'deploy:setup', 'secret:setup'

  desc 'Symlink the secret.yml file.'
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/secret.yml #{release_path}/config/secret.yml"
  end
  after 'deploy:finalize_update', 'secret:symlink'
end
