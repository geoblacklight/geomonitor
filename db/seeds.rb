# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'json'

data = JSON::parse(File.read('data/transformed.json'))

# wms = data.map { |x|  [x['dct_provenance_s'], x['solr_wms_url']] }
#
# wms.uniq.each do |doc|
#   next unless doc[1]
#   inst = Institution.where(name: doc[0]).first_or_create
#   Host.where(url: doc[1].gsub(/\/wms/, ''), institution_id: inst.id).first_or_create
# end



data.each do |doc|
  next unless doc['dct_provenance_s']
  inst = Institution.where(name: doc['dct_provenance_s']).first_or_create
  host = Host.where(url: doc['solr_wms_url'].gsub(/\/wms/, ''), institution_id: inst.id).first_or_initialize
  unless host.persisted?
    inst_hosts = Host.where(institution_id: inst.id)
    host.name = "#{host.institution.name} #{inst_hosts.length + 1}"
    host.save
  end

  l = Layer.where(name: doc['layer_slug_s'],
              geoserver_layername: doc['layer_id_s'],
              host_id: host.id,
              access: doc['dc_rights_s'],
              bbox: doc['solr_bbox']).first_or_create


end
