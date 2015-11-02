class Spree::Admin::FosdickShipmentsController < Spree::Admin::BaseController
  respond_to :js, only: [:index]

  def index
    params[:q] ||= {}

    params_clone = params[:q].deep_dup

    [:created_at_gt, :created_at_lt, :ship_date_gt, :ship_date_lt].each do |date_param|
      if params_clone[date_param].present?
        params_clone[date_param] = Time.zone.parse(params_clone[date_param]).beginning_of_day rescue ''
      end
    end

    @search = Spree::FosdickShipment.includes(:fosdick_exceptions).ransack(params_clone)
    @fosdick_shipments = @search.result(distinct: true).page(params[:page]).per(Spree::Config[:admin_products_per_page]).order(created_at: :desc)
  end
end
