require 'spec_helper'

RSpec.describe Spree::Shipment, type: :model do
  describe 'relationships with other entities' do
    it { should have_one(:fosdick_shipment)}
  end

  describe 'class methods' do
    let!(:shipment) { create :shipment, shipped_at: nil, state: 'ready', send_atempt: 0 }
    let!(:result)   { JSON.parse(
      { 'id'=>'H58716774464',
        'order_id'=>'R547700419',
        'email'=>'georgiana@armstrong.co.uk',
        'cost'=>100.0,
        'status'=>'ready',
        'stock_location'=>'NY Warehouse',
        'shipping_method'=>nil,
        'tracking'=>'U10000',
        'placed_on'=>'',
        'shipped_at'=>nil,
        'totals'=>
          { 'item'=>'$0.00',
            'adjustment'=>'$0.00',
            'tax'=>'$0.00',
            'shipping'=>'$0.00',
            'payment'=>'0.0',
            'order'=>'$0.00'},
        'updated_at'=>'2015-11-13T13:18:31Z',
        'channel'=>'spree',
        'items'=>[],
        'shipping_method_code'=>'UPS_GROUND',
        'billing_address'=>
          { 'firstname'=>'John',
            'lastname'=>'Doe',
            'address1'=>'10 Lovely Street',
            'address2'=>'Northwest',
            'zipcode'=>'35005',
            'city'=>'Herndon',
            'state'=>'AL',
            'country'=>'US',
            'phone'=>'555-555-0199'},
        'shipping_address'=>nil}.to_json) }

    before { allow(ActiveModel::ArraySerializer).to receive(:new).and_return([result]) }

    it 'should perform shipments to fosdick' do
      expect(Spree::Shipment.perform_fosdick_shipments).to eq [result]
    end
  end
end
