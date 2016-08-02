class Ping < ActiveRecord::Base
  belongs_to :endpoint, counter_cache: true, touch: true

  def self.check_status(endpoint)
    Geomonitor.logger.debug "Pinging #{endpoint.url} ..."
    begin
      p = Net::Ping::HTTP.new(endpoint.url).ping?
    rescue URI::InvalidURIError => error
      Geomonitor.logger.error "#{error} url is \"#{host.url}\" for host_id #{host.id}"
      p = false
    end
    Geomonitor.logger.info "Ping result: #{p}"
    current = Ping.create(endpoint: endpoint, status: p, latest: true)

    old_pings = Ping.where(endpoint: endpoint).where('id != ?', current.id)

    if old_pings.length > 0
      old_pings.each do |old|
        old.latest = false
        old.save
      end
    end
  end

  def self.recent_status
    last.status if last
  end
end
