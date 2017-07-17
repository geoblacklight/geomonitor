# config valid only for Capistrano 3.1
lock '3.4.1'

set :application, 'geomonitor'
set :repo_url, 'https://github.com/geoblacklight/geomonitor.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
ask :user, 'geostaff'
set :home_directory, "/opt/app/#{fetch(:user)}"

set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/solr.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{data config/settings log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
task :prepare_bundle_config do
  'bundle config build.pg --with-pg-config=/usr/pgsql-9.2/bin/pg_config'
end

namespace :deploy do

  before 'bundler:install', 'prepare_bundle_config'

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
