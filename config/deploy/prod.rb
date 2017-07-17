set :deploy_host, ask('Server', 'e.g. server.stanford.edu')
set :bundle_without, %w{development test}.join(' ')

server fetch(:deploy_host), user: fetch(:user), roles: %w{web db app whenever}

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
