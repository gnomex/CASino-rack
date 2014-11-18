require 'mina/rvm'
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/unicorn'

set :domain, '192.168.122.74'

set :deploy_to, '/var/www/casino-rack'
set :app_path, "#{deploy_to}/current"
set :release_path, "#{deploy_to}/current"
set :repository, 'https://github.com/gnomex/CASino-rack.git'
set :branch, 'master'
set_default :rails_env, 'production'
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
# set :unicorn_pid, "#{app_path}/tmp/pids/unicorn.pid"

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'config/unicorn.rb', 'log', 'vendor/assets/bower', 'config/cas.yml']

# Optional settings:
set :user, 'deploy'
# set :port, 3245
set :forward_agent, true

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rvm:use[ruby-2.1.3@mina-casino-rack]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %{
    mkdir -p "#{deploy_to}/shared/tmp/pids"
  }
end

desc "Run bower"
task :bower do
  queue! %[bower install]
end

desc "Crate database and run migrations"
task :database do
  queue! %[bundle exec rake db:setup RAILS_ENV='production']
  # invoke :'rails:db_migrate'
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'bower'
    invoke :'database'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'unicorn:restart'
    end
  end
end
