require 'open-uri'
require 'net/http'

module Fosdick
  class Receiver

    def initialize(end_point, request_options={})
      @end_point       = end_point
      @request_options = request_options
    end

    def call_api(fosdick_options)
      fetch_data(@end_point, fosdick_options)
    end

    private

    def fetch_data(end_point, options={})
      # required sleep 2 sec for Fosdick API
      sleep 2
      response = request(end_point, options)
      # process only valid to JSON.parse data
      begin
        response.nil? ? nil : JSON.parse(response.body)
      rescue JSON::ParserError
        nil
      end
    end

    def api_url(end_point)
      "https://www.customerstatus.com/fosdickapi/#{end_point}?#{ { }.merge(@request_options).to_query }"
    end

    def request(end_point, options={})
      uri = URI(api_url(end_point))

      Net::HTTP.start(uri.host, uri.port,
                      use_ssl: uri.scheme == 'https',
                      verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|

        request = Net::HTTP::Get.new uri.request_uri
        request['Accept'] = 'application/json'
        request.basic_auth(options['basic_auth']['login'], options['basic_auth']['password']) if options['basic_auth'].present?

        http.request request
      end
    end
  end
end
