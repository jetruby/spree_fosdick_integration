require 'spec_helper'

RSpec.describe Fosdick::Processor, type: :services do
  before { stub_const 'FOSDICK_CONFIG', {
      'test'        =>true,
      'ipost_uri'   =>'https://www.unitycart.com',
      'client_name' =>'test',
      'adcode'      =>'TEST',
      'client_code' =>'TEST_CODE',
      'basic_auth'  =>{
          'login'   =>'TESTLOG',
          'password'=>'password'}
  }}

  let(:config) { FOSDICK_CONFIG }
  let!(:order_ready_to_ship) {create :order_ready_to_ship}

  describe 'sender service logic' do
    let(:doc) {Fosdick::Documents::Shipment.new(Spree::Shipment.perform_fosdick_shipments.first, config).to_xml}
    let(:response) { '<UnitycartOrderResponse xml:lang="en-US">
                      <OrderResponse ExternalID="YourID">
                        <SuccessCode>True</SuccessCode>
                        <OrderNumber>2679987865</OrderNumber>
                      </OrderResponse>
                    </UnitycartOrderResponse>'}

    before {
      stub_request(:post, "https://www.unitycart.com/test/cart/ipost.asp").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => response, :headers => {})
    }

    it 'should send new shipment to fosdick' do
      eligible_shipment = Spree::Shipment.perform_fosdick_shipments.last

      expect{Fosdick::Processor.send_shipment(eligible_shipment, config)}.to change{Spree::FosdickShipment.count}.from(0).to(1)
      expect(Spree::FosdickShipment.last.external_order_num).to eq order_ready_to_ship.shipments.first.number
      expect(Spree::FosdickShipment.last.fosdick_order_num).to eq '2679987865'
      expect(Spree::FosdickShipment.last.state).to eq 'sent'
      expect(Spree::FosdickShipment.last.tracking_number).to eq nil
      expect(Spree::FosdickShipment.last.ship_date).to eq nil

      expect(Spree::Shipment.last.state).to eq 'shipped'
      expect(Spree::Shipment.last.fosdick_state).to eq 'success'
    end
  end

  describe 'receiver service logic' do
    let!(:fosdick_shipment) {create :fosdick_shipment, external_order_num: 'H0011001',
                                                       spree_shipment_id: order_ready_to_ship.shipments.last.id,
                                                       tracking_number: nil}
    let(:response) { '[
    {
      "fosdick_order_num": "00101201506460001",
      "external_order_num": "H0011001",
      "ship_date": "2015-02-06",
      "trackings": [
        {
          "tracking_num": "9274899998944522337",
          "carrier_code": "92",
          "carrier_name": "FEDEX SMART POST"
        },
        {
          "tracking_num": "9274899998944599999",
          "carrier_code": "92",
          "carrier_name": "FEDEX SMART POST"
        }
      ]
    }]'}

    before {
      stub_request(:get, "https://TESTLOG:password@www.customerstatus.com/fosdickapi/shipmentdetail.json?external_order_num=#{fosdick_shipment.external_order_num}").
          with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => response, :headers => {})
    }
    before { Spree::Shipment.last.update_column(:number, 'H0011001')}
    before { ActionMailer::Base.deliveries.clear }

    it 'should receive shipment details from fosdick' do
      Fosdick::Processor.receive_shipment({external_order_num: 'H0011001'}, 'shipmentdetail.json' )

      expect(Spree::FosdickShipment.last.tracking_number).to eq (['9274899998944522337', '9274899998944599999'])
      expect(Spree::FosdickShipment.last.confirmation_sent).to eq true
      expect(Spree::FosdickShipment.last.ship_date).to eq '2015-02-06 00:00:00'
      expect(Spree::FosdickShipment.last.fosdick_order_num).to eq '00101201506460001'
    end

    it 'should notify user by email that order shipped' do

      expect{Fosdick::Processor.receive_shipment({external_order_num: 'H0011001'}, 'shipmentdetail.json' )}.to change{ActionMailer::Base.deliveries.count}.from(0).to(1)
    end
  end
end
