require 'spec_helper'

RSpec.describe Spree::FosdickShipment, type: :model do
  describe 'relationships with other entities' do
    it { should belong_to(:shipment).class_name('Spree::Shipment')}
    it { should have_many(:fosdick_exceptions)}
    it { should serialize(:tracking_number)   }
  end
end
