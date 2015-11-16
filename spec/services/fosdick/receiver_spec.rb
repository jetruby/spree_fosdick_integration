require 'spec_helper'
require 'json'

RSpec.describe Fosdick::Receiver, type: :services do
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

  let(:fosdick_shipment) {create :fosdick_shipment}
  let(:config) { FOSDICK_CONFIG }
  let(:response) { '[
    {
      "fosdick_order_num": "00101201506460001",
      "external_order_num": "0011001",
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
  it {expect(Fosdick::Receiver.new('shipmentdetail.json', {external_order_num: fosdick_shipment.external_order_num}).call_api(config)).to eq JSON.parse(response)}
end