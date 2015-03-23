module Geomonitor
  class Response
    attr_reader :status, :response_code, :body
    def initialize(response = {})
      @response = response
      parse_response
    end

    ##
    # Determines whether the response is an exception
    # @return [Boolean]
    def is_an_exception?
      true if @response.try(:exception)
    end

    ##
    # Method evaluates a response and sets appropriate instance variables
    def parse_response
      if is_an_exception?
        @status = 'FAIL'
        @response_code = '504'
        @body = 'Request Timeout'
      elsif @response.headers[:content_type] == 'image/png'
        @status = 'OK'
        @response_code = @response.status
        @body = 'image/png'
      else
        @status = '??'
        @response_code = @response.status
        @body = @response.body
      end
    end
  end
end
