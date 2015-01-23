# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Geomonitor::Application.load_tasks

desc 'Execute the test build that runs on travis'
task :ci => [:environment] do
  if Rails.env.test?
    Rake::Task['db:migrate'].invoke
    Rake::Task['spec'].invoke
  else
    system('rake ci RAILS_ENV=test')
  end
end
