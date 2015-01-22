module Geomonitor
  module Indexer
    
    def get_all_document_ids
      begin
        query = query_solr params: {
          q: '*:*',
          fl: 'layer_slug_s',
          rows: 100000
        }
        query['response']['docs'].map { |doc| doc['layer_slug_s'] }
      end
    end

    def find_document(id)
      query = query_solr params: {
        q: "layer_slug_s:#{id}"
      }
      query['response']['docs'].first
    end

    def document_solr_score(id)
      find_document(id)['layer_availability_score_f']
    end

    def query_solr(search_params = params || {})
      Geomonitor::SolrConfiguration.solr.get 'select', search_params
    end
  end
end
