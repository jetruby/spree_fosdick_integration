require 'spec_helper'

RSpec.describe Spree::Admin::FosdickShipmentsController, type: :controller do
  describe '#index' do
    let!(:fosdick_shipment) { create :fosdick_shipment }
    let!(:admin)            { create :admin_user }
    before { sign_in(admin) }

    it 'should have 200 response' do
      get :index, { use_route: SpreeFosdickIntegration }

      expect(response.status).to eq(200)
      expect(assigns[:fosdick_shipments]).to eq [fosdick_shipment]
    end
  end
end