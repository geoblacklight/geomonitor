module Geomonitor
  require 'geomonitor/indexer'
  require 'geomonitor/solr_configuration'
  require 'geomonitor/tools'

  extend Geomonitor::Indexer

  def self.logger
    ::Rails.logger
  end
end
