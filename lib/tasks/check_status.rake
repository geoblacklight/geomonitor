# Rake tasks to check layers
  namespace :layers do
    desc 'Check status of active layers that have no status'
    task :check_empties => :environment do

      # Get layers that have not been status checked
      layers = Layer.where(active: true).where('id NOT IN (SELECT DISTINCT(layer_id) FROM statuses)')

      layers.shuffle.each do |layer|

        # Skip if host is not pingable
        next if layer.host.pings.last.nil?
        next unless layer.host.pings.last.status

        # Skip if access is restricted
        next if layer[:access] == 'Restricted'
        Status.run_check(layer)
      end
    end
    desc 'Check active layers'
    task :check_all => :environment do
      layers = Layer.where(active: true)
      layers.shuffle.each do |layer|

        # Skip if host is not pingable
        next unless layer.host.pings.last.status

        # Skip if access is restricted
        next if layer[:access] == 'Restricted'

        # Run status check
        Status.run_check(layer)
      end
    end
    desc 'Check Stanfords active layers'
    task :check_stanford => :environment do
      institution = Institution.find_by name: "Stanford"
      stanford_hosts = Host.where(institution_id: institution.id)
      layers = Layer.where(host_id: stanford_hosts, active: true)
      layers.shuffle.each do |layer|
        Status.run_check(layer)
      end
    end
  end

  namespace :ping do
    desc 'Ping all hosts'
    task :hosts => :environment do
      hosts = Host.all()
      hosts.shuffle.each do |host|
        Ping.check_status(host)
      end
    end
  end
