module Fosdick
  class Sender
    include HTTParty
    base_uri FOSDICK_CONFIG['ipost_uri']
    format :xml

    def self.send_doc(doc, config)
      client = config['client_name']

      begin
        # required sleep 2 sec for Fosdick Shopping Cart iPost interface
        sleep 2
        res  = post("/#{client}/cart/ipost.asp", body: doc)
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError

        raise Fosdick::SendError
      end
      return validate_and_return(res)
    end

    private

    def self.validate_and_return(response)
      order_response = response['UnitycartOrderResponse']['OrderResponse']

      if order_response['SuccessCode'] == 'True'
        order_response['OrderNumber']
      else
        {
          code:   order_response['ErrorCode'],
          errors: order_response['Errors']
        }
      end
    end
  end

  class SendError < StandardError; end
end
