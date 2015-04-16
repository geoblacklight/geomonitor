namespace :solr do
  desc 'Save new layers from Solr'
  task update_layers: :environment do
    Geomonitor.get_all_document_ids.each do |name_id|
      # Check to see if the layer already exists
      l = Layer.find_by_name(name_id)
      if l.nil?
        doc = Geomonitor.find_document(name_id)
        if doc.present?
          wms = JSON.parse(doc['dct_references_s']).try(:[], 'http://www.opengis.net/def/serviceType/ogc/wms')
          if wms
            wms = wms.gsub('/wms', '')
            doc_institution = doc['dct_provenance_s']
            institution = Institution.find_or_create_by(name: doc_institution)
            host = Host.find_or_create_by(url: wms, institution_id: institution.id) do |host|
              host.name = "#{institution.name}"
            end
            begin
              puts doc['georss_box_s']
              georss_bbox = doc['georss_box_s'].split(' ')
              Layer.create(
                name: name_id,
                host_id: host.id,
                geoserver_layername: doc['layer_id_s'],
                access: doc['dc_rights_s'],
                bbox: "#{georss_bbox[1]} #{georss_bbox[0]} #{georss_bbox[3]} #{georss_bbox[2]}",
                active: true
              )
            rescue NoMethodError => e
              Rails.logger.error "#{e} for #{name_id}"
            end
          end
        end
      end
    end
  end
  desc 'Save new layers from Solr and ping hosts'
  task update_and_ping: :environment do
    Rake::Task['solr:update_layers'].invoke
    Rake::Task['ping:hosts'].invoke
  end
  desc 'Deactivate non-Solr layers'
  task deactivate: :environment do
    solr_current = Geomonitor.get_all_document_ids
    if solr_current.count > 0
      Layer.where.not(name: solr_current).each do |layer|
        layer.active = false
        layer.save
        Rails.cache.delete("host/#{layer.host_id}/layers_count")
      end
    end
  end
  desc 'Activate Solr layers'
  task activate: :environment do
    solr_current = Geomonitor.get_all_document_ids
    solr_current.each do |solr_name|
      layer = Layer.find_by_name(solr_name)
      if layer
        layer.active = true
        layer.save
        Rails.cache.delete("host/#{layer.host_id}/layers_count")
      end
    end
  end
end
