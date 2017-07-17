set :bundle_without, %w{development test}.join(' ')

server 'kurma-monitor-prod.stanford.edu', user: fetch(:user), roles: %w{web db app whenever}

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
