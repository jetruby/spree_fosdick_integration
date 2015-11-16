require 'active_model/serializer'

class ShipmentSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :email, :cost, :status, :stock_location,
            :shipping_method, :tracking, :placed_on, :shipped_at, :totals,
            :updated_at, :channel, :items, :shipping_method_code

  has_one :bill_to, serializer: AddressSerializer, root: 'billing_address'
  has_one :ship_to, serializer: AddressSerializer, root: 'shipping_address'

  def id
    object.number
  end

  def order_id
    object.order.number
  end

  def email
    object.order.email
  end

  def channel
    object.order.channel || 'spree'
  end

  def cost
    object.cost.to_f
  end

  def status
    object.state
  end

  def stock_location
    object.stock_location.name
  end

  def shipping_method
    if object.shipping_method.try(:name)
      if object.shipping_method.try(:name).include?('Standard') || object.shipping_method.try(:name).include?('Free')
        ''
      elsif object.shipping_method.try(:name).include?('Expedited')
        object.shipping_method.try(:code)
      end
    else
      ''
    end
  end

  def shipping_method_code
    object.shipping_method.try(:code)
  end

  def placed_on
    if object.order.completed_at?
      object.order.completed_at.getutc.try(:iso8601)
    else
      ''
    end
  end

  def shipped_at
    object.shipped_at.try(:iso8601)
  end

  def totals
    {
      item: object.order.display_item_total.to_s,
      adjustment: object.order.display_adjustment_total.to_s, #adjustment_total.to_s,
      tax: object.order.display_tax_total.to_s, #tax_total.to_s,
      shipping: object.order.display_ship_total.to_s, #shipping_total.to_s
      payment: object.order.payments.completed.sum(:amount).to_s,
      order: object.order.display_total.to_s
    }
  end

  def updated_at
    object.updated_at.iso8601
  end

  def items
    i = []
    object.inventory_units.each do |inventory_unit|
      i << InventoryUnitSerializer.new(inventory_unit, root: false)
    end
    i
  end

  private

  def adjustment_total
    object.order.adjustment_total.to_f
  end

  def shipping_total
    object.order.shipment_total.to_f
  end

  def tax_total
    object.order.tax_total.to_f
  end

end
