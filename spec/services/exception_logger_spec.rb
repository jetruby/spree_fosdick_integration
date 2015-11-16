require 'spec_helper'

RSpec.describe ExceptionLogger, type: :services do
  let!(:fosdick_shipment) { create :fosdick_shipment }

  it 'should log exceptions' do
    ExceptionLogger.new.log('Error', 'Error - Unknown Shipping Method: 0099DEX', fosdick_shipment.id)

    expect(Spree::FosdickException.last.fosdick_shipment).to eq fosdick_shipment
  end
end
