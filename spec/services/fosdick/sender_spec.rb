require 'spec_helper'

RSpec.describe Fosdick::Sender, type: :services do
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

  let!(:order_ready_to_ship) {create :order_ready_to_ship}

  let(:config) { FOSDICK_CONFIG }
  let(:doc) {Fosdick::Documents::Shipment.new(Spree::Shipment.perform_fosdick_shipments.first, config).to_xml}
  let(:response) { '<UnitycartOrderResponse xml:lang="en-US">
                      <OrderResponse ExternalID="YourID">
                        <SuccessCode>True</SuccessCode>
                        <OrderNumber>2679987865</OrderNumber>
                      </OrderResponse>
                    </UnitycartOrderResponse>'}

  before {
    stub_request(:post, "https://www.unitycart.com/test/cart/ipost.asp").
      with(:body    => doc,
           :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => response, :headers => {})
  }

  it {expect(Fosdick::Sender.send_doc(doc, config)).to eq '2679987865'}
end