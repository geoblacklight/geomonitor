namespace :solr do
  desc 'Save new layers from Solr'
  task update_layers: :environment do
    Geomonitor.get_all_document_ids.each do |name_id|
      # Check to see if the layer already exists
      l = Layer.find_by_name(name_id)
      if l.nil?
        doc = Geomonitor.find_document(name_id)
        wms = JSON.parse(doc['dct_references_s'])['http://www.opengis.net/def/serviceType/ogc/wms']
        if wms
          doc_institution = doc['dct_provenance_s']
          institution = Institution.find_or_create_by(name: doc_institution)
          host = Host.find_or_create_by(url: wms, institution_id: institution.id) do |host|
            host.name = "#{institution.name}"
          end
          Layer.create(
            name: name_id,
            host_id: host.id,
            geoserver_layername: doc['layer_id_s'],
            access: doc['dc_rights_s'],
            bbox: doc['solr_bbox']
          )
        end
      end
    end
  end
  desc 'Set stale Geomonitor layers based off of Solr'
  task set_stale_layers: :environment do
    
  end
end
