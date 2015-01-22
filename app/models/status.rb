require 'net/http'
require 'rest_client'
require 'geomonitor'

class Status < ActiveRecord::Base
  belongs_to :layer, counter_cache: true, touch: true

  def self.run_check(layer)
    Geomonitor::Tools.verbose_sleep(rand(1..5))
    puts "Checking #{layer.name}"
    options = {
      'SERVICE' => 'WMS',
      'VERSION' => '1.1.1',
      'REQUEST' => 'GetMap',
      'LAYERS' => layer.geoserver_layername,
      'STYLES' => '',
      'CRS' => 'EPSG:900913',
      'SRS' => 'EPSG:3857',
      'BBOX' => Geomonitor::Tools.bbox_format(layer.bbox),
      'WIDTH' => '256',
      'HEIGHT' => '256',
      'FORMAT' => 'image/png',
      'TILED' => true
    }

    uri = URI(layer.host.url + '/wms')
    uri.query = URI.encode_www_form(options)

    start_time = Time.now
    resource = RestClient::Resource.new(
      layer.host.url + '/wms',
      timeout: 10,
      open_timeout: 10
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

    puts "Status: #{status} #{res_code} in #{elapsed_time} seconds"

    old_score = layer.recent_status_score
    current = Status.create(res_code: res_code,
                            latest: true,
                            res_time: elapsed_time,
                            status: status,
                            status_message: body,
                            submitted_query: uri.to_s,
                            layer_id: layer.id)

    old_statuses = Status.where(layer_id: layer.id)
                         .where('id != ?', current.id)
                         .where(latest: true)

    current.update_cache(old_statuses.last)
    new_score = layer.recent_status_score

    if old_score != new_score
      if layer.recent_status_solr_score != new_score
        layer.update_solr_score
      end
    end

    if old_statuses.length > 0
      old_statuses.each do |old|
        old.latest = false
        old.save
      end
    end
  end

  def self.status_groups
    select(:status).group(:status)
  end

  def self.latest
    where(latest: true)
  end

  def host
    layer.host
  end

  # private

  ##
  # Checks to see if the current status is different the previous
  # status.
  # @param [Status]
  def new_status_different?(previous)
    return true unless previous.present?
    status == previous.status
  end

  ##
  # Update cache if current status is different from previous status
  # @param [Status]
  def update_cache(previous)
    host.overall_status force_update: true if new_status_different?(previous)
  end
end
