module Geomonitor::Tools
  def self.verbose_sleep(time)
    puts "Waiting for #{time} seconds"
    sleep(time)
  end
end
