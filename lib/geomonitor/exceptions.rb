module Geomonitor
  module Exceptions
    class TileGrabFailed < StandardError
      def initialize(options = {})
        @options = options
      end
    end
  end
end