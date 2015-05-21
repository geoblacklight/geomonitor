# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}
#

# Only set cron jobs in production

every '15 */2 * * *', :roles => [:whenever] do
  rake 'layers:check_stanford'
end

every '45 16 */2 * *', :roles => [:whenever] do
  rake 'layers:check_all'
end

every '45 */6 * * *', :roles => [:whenever] do
  rake 'solr:update_and_ping'
end

every '0 1 * * 6', :roles => [:web] do
  rake 'clean:status'
end

# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
