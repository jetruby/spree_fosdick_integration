FactoryGirl.define do
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_fosdick_integration/factories'

  factory :fosdick_shipment, class: Spree::FosdickShipment do
    shipment
    fosdick_order_num '5177595188'
    external_order_num 'H28547338764'
    tracking_number nil
    state 'sent'
    confirmation_sent false
    ship_date nil

    factory :fosdick_shipment_shipped do
      fosdick_order_num '00501201556352008'
      tracking_number ['9261295598944533641919']
      state 'shipped'
      confirmation_sent true
      ship_date {Time.zone.now}
    end
  end

  factory :fosdick_exception, class: Spree::FosdickException do
    fosdick_shipment

    error_code  'Error'
    message     'Error - Unknown Shipping Method: 0099DEX'
    state       'error'
    happened_at {Time.zone.now}
  end
end
