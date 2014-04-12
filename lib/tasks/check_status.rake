# Rake tasks to check layers
  namespace :layers do
    desc 'Check status of layers that have no status'
    task :check_empties => :environment do
      status_count = Status.all().count
      layer_count = Layer.all().count

      l = Layer.where('id NOT IN (SELECT DISTINCT(layer_id) FROM statuses)')

      l.shuffle.each do |layer|
        next if layer[:access] == 'Restricted'
        Status.run_check(layer)
      end
    end
    desc 'Check everything'
    task :check_all => :environment do
      layers = Layer.all()
      layers.shuffle.each do |layer|
        next if layer[:access] == 'Restricted'
        Status.run_check(layer)
      end
    end
    desc 'Check Stanfords layers'
    task :check_stanford => :environment do
      institution = Institution.find_by name: "Stanford"
      stanford_hosts = Host.where(institution_id: institution.id)
      layers = Layer.where(host_id: stanford_hosts)
      layers.shuffle.each do |layer|
        Status.run_check(layer)
      end
    end
  end
