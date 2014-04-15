module Geomonitor::Tools
  def self.verbose_sleep(time)
    puts "Waiting for #{time} seconds"
    sleep(time)
  end
  def self.json_as_utf(json_string)
    json_string.gsub!(/\\u([0-9a-z]{4})/) {|s| [$1.to_i(16)].pack("U")}
  end
end
