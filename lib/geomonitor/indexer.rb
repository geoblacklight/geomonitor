module Geomonitor
  module Indexer

    def get_all_document_ids
      begin
        query = query_solr params: {
          q: '*:*',
          fl: 'layer_slug_s',
          rows: 100000
        }
        query.try(:[], 'response').try(:[], 'docs').map { |doc| doc.try(:[], 'layer_slug_s') }
      end
    end

    def find_document(id)
      query = query_solr params: {
        q: "layer_slug_s:#{id}"
      }
      query['response']['docs'].first
    end

    def document_solr_score(id)
      doc = find_document(id)
      return doc['layer_availability_score_f'] unless doc.nil?
    end

    def query_solr(search_params = params || {})
      Geomonitor::SolrConfiguration.solr.get 'select', search_params
    end

    def update_by_id(params)
      data = [{ layer_slug_s: params[:id], layer_availability_score_f: { set: params[:score] } }]
      update(data)
    end

    ##
    # Query for a Solr document and return it's uuid
    # @param [String] id a layer_slug_s id field
    # @return [String]
    def uuid_from_id(id)
      find_document(id)['uuid']
    rescue NoMethodError
      raise Geomonitor::Exceptions::NoDocumentFound.new, "Could not find: #{id}"
    end

    def update(data)
      Geomonitor::SolrConfiguration.solr.update params: { commitWithin: 500, overwrite: true },
                                                data: data.to_json, 
                                                headers: { 'Content-Type' => 'application/json' }
    end
  end
end
