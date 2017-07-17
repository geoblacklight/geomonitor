set :bundle_without, %w{production test}.join(' ')

server 'kurma-monitor-dev.stanford.edu', user: fetch(:user), roles: %w{web db app}

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'development'
