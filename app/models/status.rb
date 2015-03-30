require 'net/http'
require 'rest_client'
require 'geomonitor'

class Status < ActiveRecord::Base
  belongs_to :layer, counter_cache: true, touch: true

  def self.run_check(layer)
    Geomonitor::Tools.verbose_sleep(rand(1..5))
    Geomonitor.logger.info "Checking layer #{layer.name}"

    client = Geomonitor::Client.new(layer)
    response = client.create_response

    Geomonitor.logger.info "Status: #{response.status} #{response.response_code} in #{client.elapsed_time} seconds"

    old_score = layer.recent_status_score
    current = Status.create(res_code: response.response_code,
                            latest: true,
                            res_time: client.elapsed_time,
                            status: response.status,
                            status_message: response.body,
                            submitted_query: response.request_url,
                            layer_id: layer.id)

    old_statuses = Status.where(layer_id: layer.id)
                         .where('id != ?', current.id)
                         .where(latest: true)

    current.update_cache(old_statuses.last)
    new_score = layer.recent_status_score

    layer_recent_status_solr_score = layer.recent_status_solr_score

    if layer_recent_status_solr_score.blank? || layer_recent_status_solr_score != new_score
      Geomonitor.logger.info "Score in Solr is different, updating Solr"
      layer.update_solr_score
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

  def self.active
    joins(:layer).where(layers: { active: true })
  end

  def host
    layer.host
  end

  ##
  # Update cache if current status is different from previous status
  # @param [Status]
  def update_cache(previous)
    host.overall_status force_update: true if new_status_different?(previous)
  end

  private

  ##
  # Checks to see if the current status is different the previous
  # status.
  # @param [Status]
  def new_status_different?(previous)
    return true unless previous.present?
    status != previous.status
  end
end
