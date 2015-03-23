module Geomonitor
  class Client
    attr_accessor :start_time, :end_time
    # attr_writer :start_time, :end_time

    ##
    # Create a Geomonitor::Client based off of a Layer
    # @param [Geomonitor::Layer]
    def initialize(layer, options = {})
      @layer = layer
      @options = options
    end

    ##
    # Options used for tile request
    # @return [Hash]
    def request_params
      {
        'SERVICE' => 'WMS',
        'VERSION' => '1.1.1',
        'REQUEST' => 'GetMap',
        'LAYERS' => @layer.geoserver_layername,
        'STYLES' => '',
        'CRS' => 'EPSG:900913',
        'SRS' => 'EPSG:3857',
        'BBOX' => Geomonitor::Tools.bbox_format(@layer.bbox),
        'WIDTH' => '256',
        'HEIGHT' => '256',
        'FORMAT' => 'image/png',
        'TILED' => true
      }
    end

    ##
    # url used for tile request
    # @return [String]
    def url
      @layer.host.url + '/wms'
    end

    ##
    # Starts a response, it's timer, and then creates a Geomonitor::Repsponse
    # @return [Geomonitor::Response]
    def create_response
      @start_time = Time.now
      begin
        response = grab_tile
      rescue Geomonitor::Exceptions::TileGrabFailed => error
        response = error
      end
      @end_time = Time.now
      Geomonitor::Response.new(response)
    end

    ##
    # Initiates tile request from a remote WMS server. Will catch
    # Faraday::Error::ConnectionFailed and Faraday::Error::TimeoutError
    # @return [Faraday::Request] returns a Faraday::Request object
    def grab_tile
      conn = Faraday.new(url: url)
      conn.get do |request|
        request.params = request_params
        request.options = {
          timeout: timeout,
          open_timeout: timeout
        }
      end
    rescue Faraday::Error::ConnectionFailed
      raise Geomonitor::Exceptions::TileGrabFailed, message: 'Connection failed', url: conn.url_prefix.to_s
    rescue Faraday::Error::TimeoutError
      raise Geomonitor::Exceptions::TileGrabFailed, message: 'Connection timeout', url: conn.url_prefix.to_s
    end

    ##
    # Elapsed tile request time in seconds
    # @return [Float]
    def elapsed_time
      @end_time - @start_time if @start_time && @end_time
    end

    private

    ##
    # Returns timeout for the external request
    # @return [Fixnum] request timeout in seconds
    def timeout
      @options[:timeout] || 10
    end
  end
end
