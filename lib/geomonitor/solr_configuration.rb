module Geomonitor
  module SolrConfiguration

    ##
    # Taken from the way Blacklight configures Solr
    # Looks for a config/solr.yml
    def self.solr_file
      "#{::Rails.root.to_s}/config/solr.yml"
    end

    def self.solr
      @solr ||=  RSolr.connect(Geomonitor::SolrConfiguration.solr_config)
    end

    def self.solr_config
      @solr_config ||= begin
        fail "The #{::Rails.env} environment settings were not found in the solr.yml config" unless solr_yml[::Rails.env]
        solr_yml[::Rails.env].symbolize_keys
      end
    end

    def self.solr_yml
      require 'erb'
      require 'yaml'

      return @solr_yml if @solr_yml
      unless File.exists?(solr_file)
        fail "You are missing a solr configuration file: #{solr_file}."
      end

      begin
        @solr_erb = ERB.new(IO.read(solr_file)).result(binding)
      rescue Exception => e
        raise("solr.yml was found, but could not be parsed with ERB. \n#{$!.inspect}")
      end

      begin
        @solr_yml = YAML::load(@solr_erb)
      rescue StandardError => e
        raise("solr.yml was found, but could not be parsed.\n")
      end

      if @solr_yml.nil? || !@solr_yml.is_a?(Hash)
        fail("solr.yml was found, but was blank or malformed.\n")
      end

      @solr_yml
    end
  end
end
