require 'spec_helper'

RSpec.describe Spree::FosdickException, type: :model do
  describe 'relationships with other entities' do
    it { should belong_to(:fosdick_shipment).class_name('Spree::FosdickShipment')}
  end

  describe 'instance methods' do
    let(:shipment)          {create :shipment}
    let(:fosdick_shipment)  {create :fosdick_shipment,  shipment: shipment}
    let(:fosdick_exception) {create :fosdick_exception, fosdick_shipment: fosdick_shipment}

    it 'should update fosdick state of a shipment after creation' do
      expect(fosdick_exception.shipment.fosdick_state).to eq 'exception'
    end

    it 'should return shipment for current fosdick exception' do
      expect(fosdick_exception.shipment).to eq shipment
    end
  end
end
