module Geomonitor
  require 'geomonitor/client'
  require 'geomonitor/exceptions'
  require 'geomonitor/indexer'
  require 'geomonitor/response'
  require 'geomonitor/solr_configuration'
  require 'geomonitor/tools'

  extend Geomonitor::Indexer

  def self.logger
    ::Rails.logger
  end
end
