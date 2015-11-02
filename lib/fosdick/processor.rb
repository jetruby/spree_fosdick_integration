module Fosdick
  class Processor
    def self.send_shipment(shipment, config)
      doc = Fosdick::Documents::Shipment.new(shipment, config).to_xml
      res = Fosdick::Sender.send_doc(doc, config)

      log_fosdick_shipment(shipment, res)
    end

    def self.receive_shipment(options={})
      res = Fosdick::Receiver.new('shipments.json', options).call_api(FOSDICK_CONFIG)

      update_shipment_info(res, options)
    end

    private

    def self.log_fosdick_shipment(shipment, fosdick_response)
      spree_shipment = Spree::Shipment.find_by_number(shipment['id'])

      if fosdick_response.is_a? String
        Spree::FosdickShipment.where(fosdick_order_num: fosdick_response).first_or_create(
          spree_shipment_id:  spree_shipment.id,
          external_order_num: shipment['id'],
          state:             'sent')
        spree_shipment.update(state: 'shipped', fosdick_state: 'success')

      else
        fosdick_shipment = Spree::FosdickShipment.create(
          spree_shipment_id:  spree_shipment.id,
          external_order_num: shipment['id'],
          state:              'exception')
        Array(fosdick_response[:errors]).map {|exception| ExceptionLogger.new.log(fosdick_response[:code], exception.join(' - '), fosdick_shipment.id)}
      end

      spree_shipment.increment!(:send_atempt)
    end

    def self.update_shipment_info(fosdick_response, options)
      fosdick_shipment = Spree::FosdickShipment.where(fosdick_order_num: options[:fosdick_order_num]).first_or_create

      if fosdick_response.is_a? Array
        fosdick_response.each do |fos_shipment|
          trackings = []
          shipment  = fosdick_shipment.shipment
          ship_date = fos_shipment.has_key?('ship_date') ? fos_shipment['ship_date'].to_date : nil

          fos_shipment['trackings'].each {|tracking| trackings << tracking['tracking_num']}
          fosdick_shipment.update(tracking_number: trackings, ship_date: ship_date)
          shipment.update(shipped_at: ship_date, state: 'shipped', tracking: trackings.join(', ')) if shipment.present?
          shipment.order.update(shipment_state: 'shipped') if ship_date.present?

          if fosdick_shipment.confirmation_sent == false && trackings.present?
            Spree::FosdickShipmentMailer.order_shipped(shipment).deliver
            fosdick_shipment.update(confirmation_sent: true)
          end
        end
      elsif fosdick_response.is_a? Hash
        ExceptionLogger.new.log('Error', fosdick_response['error'], fosdick_shipment.id)
      end
    end
  end
end
