class Spree::Admin::FosdickShipmentsController < Spree::Admin::BaseController
  respond_to :js, only: [:index]

  def index
    @fosdick_shipments = Spree::FosdickShipment.includes(:fosdick_exceptions).page(params[:page]).per(Spree::Config[:admin_products_per_page]).order(created_at: :desc)
  end
end
