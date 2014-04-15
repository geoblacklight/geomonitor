module Geomonitor::Tools
  R = 6378137
  DEGREES_IN_CIRCLE = 360.0

  def self.verbose_sleep(time)
    puts "Waiting for #{time} seconds"
    sleep(time)
  end
  def self.json_as_utf(json_string)
    json_string.gsub!(/\\u([0-9a-z]{4})/) {|s| [$1.to_i(16)].pack("U")}
  end

  # Formats a bounding box to a WMS parameter
  # bbox_string is a string as 'w s e n'
  def self.bbox_format(bbox_string)
    bbox = bbox_string.split(' ')
    zoom = calculate_zoom_level(bbox)
    tile = get_tile_number(bbox[1].to_f, bbox[0].to_f, zoom)
    latlng = get_lat_lng_for_number(tile[:x], tile[:y], zoom)
    latlng2 = get_lat_lng_for_number(tile[:x] + 1, tile[:y] - 1, zoom)
    sw = project([latlng[:lng_deg], latlng[:lat_deg]])
    ne = project([latlng2[:lng_deg], latlng2[:lat_deg]])
    adjust_for_aspect_ratio(sw, ne)
  end

  # From http://stackoverflow.com/questions/4266754/how-to-calculate-google-maps-zoom-level-for-a-bounding-box-in-java
  # takes in bbox as string of bounding box 'w s e n'
  def self.calculate_zoom_level(bbox)
    lat_diff = bbox[3].to_f - bbox[1].to_f
    lng_diff = bbox[2].to_f - bbox[0].to_f
    max_diff = [lat_diff, lng_diff].max

    if max_diff < DEGREES_IN_CIRCLE / 2**20
      zoom = 21
    else
      zoom = -1 * ((Math.log(max_diff)/Math.log(2)) - (Math.log(360)/Math.log(2)))
      if zoom < 1
        zoom = 1
      end
    end
    zoom.ceil

  end

  # Adjusts bounding box to a 1:1 aspect ratio
  # sw is an array [w, s], ne is an array [e, n]
  def self.adjust_for_aspect_ratio(sw, ne)
    height = ne[1] - sw[1]
    width = ne[0] - sw[0]
    "#{sw[0]},#{sw[1]},#{ne[0]},#{ne[1]}"
  end

  # Project to spherical mercator
  # Algorithm used converted from JavaScript to Ruby from:
  # https://github.com/Leaflet/Leaflet/blob/master/src/geo/projection/Projection.SphericalMercator.js
  def self.project(latlng)
    d = Math::PI / 180
    max = 1 - 1E-15
    sin = [[Math.sin(latlng[1].to_f * d), max].min, -max].max
    [R * latlng[0].to_f * d, R * Math.log((1 + sin) / (1 - sin)) / 2]
  end

  # Get a tile number for a specific lat/lng at a zoom level
  # From http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Pseudo-code
  def self.get_tile_number(lat_deg, lng_deg, zoom)
    lat_rad = lat_deg/180 * Math::PI
    n = 2.0 ** zoom
    x = ((lng_deg + 180.0) / 360.0 * n).to_i
    y = ((1.0 - Math::log(Math::tan(lat_rad) + (1 / Math::cos(lat_rad))) / Math::PI) / 2.0 * n).to_i
    {:x => x, :y =>y}
  end

  # Get the lat/lng for a specific tile at a zoom level
  # From http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Pseudo-code
  def self.get_lat_lng_for_number(xtile, ytile, zoom)
    n = 2.0 ** zoom
    lon_deg = xtile / n * 360.0 - 180.0
    lat_rad = Math::atan(Math::sinh(Math::PI * (1 - 2 * ytile / n)))
    lat_deg = 180.0 * (lat_rad / Math::PI)
    {:lat_deg => lat_deg, :lng_deg => lon_deg}
  end

end
