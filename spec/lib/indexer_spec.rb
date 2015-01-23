require 'spec_helper'

describe Geomonitor::Indexer do
  describe 'get_all_document_ids' do
    let(:response) { OpenStruct.new(response: docs) }
    let(:params) { { params: { q: '*:*', fl: 'layer_slug_s', rows: 100000 } } }
    describe 'with documents in index' do
      let(:docs) { OpenStruct.new(docs: [OpenStruct.new(layer_slug_s: 'doc1'), OpenStruct.new(layer_slug_s: 'doc2')]) }
      it 'an array of document ids' do
        expect_any_instance_of(RSolr::Client).to receive(:get).with('select', params).and_return(response)
        expect(Geomonitor.get_all_document_ids).to match_array ["doc1", "doc2"]
      end
    end
    describe 'with no documents in index' do
      let(:docs) {OpenStruct.new(docs: [])}
      it 'nil if no documents are available' do  
        expect_any_instance_of(RSolr::Client).to receive(:get).with('select', params).and_return(response)
        expect(Geomonitor.get_all_document_ids).to match_array []
      end
    end
  end
  describe 'find_document' do
    let(:response) { OpenStruct.new(response: docs) }
    let(:params) { { params: { q: "layer_slug_s:#{id}"} } }
    describe 'with document available' do
      let(:docs) { OpenStruct.new(docs: [{ id: 'first doc' }]) }
      let(:id) { 'stanford-id123456' }
      it 'returns first document' do
        expect_any_instance_of(RSolr::Client).to receive(:get).with('select', params).and_return(response)
        expect(Geomonitor.find_document(id)).to eq id: 'first doc'
      end
    end
    describe 'not finding document' do
      let(:docs) { OpenStruct.new(docs: []) }
      let(:id) { 'stanford-id123456' }
      it 'returns nothing' do
        expect_any_instance_of(RSolr::Client).to receive(:get).with('select', params).and_return(response)
        expect(Geomonitor.find_document(id)).to be_nil
      end
    end
  end
  describe 'document_solr_score' do
    it 'returns the documents score from Solr' do
      doc = OpenStruct.new(layer_availability_score_f: 0.7)
      expect_any_instance_of(Geomonitor::Indexer).to receive(:find_document).with('stanford-123456').and_return(doc)
      expect(Geomonitor.document_solr_score('stanford-123456')).to eq 0.7
    end
  end
  describe 'update_by_id' do
    describe 'create data to be updated in Solr' do
      it 'should find uuid from document' do
        doc = OpenStruct.new(uuid: 'purl.stanford.edu/123456')
        expect_any_instance_of(Geomonitor::Indexer).to receive(:find_document).with('stanford-123456').and_return(doc)
        expect_any_instance_of(Geomonitor::Indexer).to receive(:update).with([{uuid: 'purl.stanford.edu/123456', layer_availability_score_f: { set: 0.7 } }])
        expect(Geomonitor.update_by_id({id: 'stanford-123456', score: 0.7})).to be_nil
      end
    end
  end
end
