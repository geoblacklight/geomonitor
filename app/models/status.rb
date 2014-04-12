require 'net/http'
require 'rest_client'

class Status < ActiveRecord::Base
  belongs_to :layer

  def self.run_check(layer)
    puts layer.inspect

    options = {
      'SERVICE' => 'WMS',
      'VERSION' => '1.1.1',
      'REQUEST' => 'GetMap',
      'LAYERS' => layer.geoserver_layername,
      'STYLES' => '',
      'SRS' => 'EPSG:4326',
      'BBOX' => layer.bbox.gsub(' ', ', '),
      'WIDTH' => '400',
      'HEIGHT' => '400',
      'FORMAT' => 'image/png'
    }

    uri = URI(layer.host.url + '/wms')
    uri.query = URI.encode_www_form(options)


    start_time = Time.now
    resource = RestClient::Resource.new(
      layer.host.url + '/wms',
      timeout: 5,
      open_timeout: 5
    )

    begin
      res = resource.get params: options
    rescue => e
      e.response
    end

    unless res
      res_code = '504'
      status = 'FAIL'
      body = 'Request Timeout'
    end

    elapsed_time = Time.now - start_time
    puts elapsed_time

    if res
      case res.headers[:content_type]
      when 'image/png'
        res_code = res.code
        status = 'OK'
        body = 'image/png'
      when 'timeout'
        status = 'timeout'
        body = 'timeout'
      else
        status = '??'
        body = res.body
      end
    end

    puts res_code

    Status.create(res_code: res_code,
                  # res_message: res.message,
                  res_time: elapsed_time,
                  status: status,
                  status_message: body,
                  submitted_query: uri.to_s,
                  layer_id: layer.id)
  end
end
