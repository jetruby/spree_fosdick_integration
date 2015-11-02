module Spree
  class FosdickShipmentMailer < ActionMailer::Base
    default from: 'spree@example.com'

    def order_shipped(shipment)
      @shipment = shipment
      @tracking = shipment.tracking,
      @order_number = shipment.order.number

      mail to: @shipment.order.email, subject: Spree.t('fosdick.order_shipped.subject')
    end
  end
end
