class Ping < ActiveRecord::Base
  belongs_to :host

  def self.check_status(host)
    puts "Pinging #{host.url} ..."
    p = Net::Ping::HTTP.new(host.url).ping?
    puts p

    current = Ping.create(host_id: host.id, status: p, latest: true)

    old_pings = Ping.where(host_id: host.id)
                    .where('id != ?', current.id)

    if old_pings.length > 0
      old_pings.each do |old|
        old.latest = false
        old.save
      end
    end

  end
end
