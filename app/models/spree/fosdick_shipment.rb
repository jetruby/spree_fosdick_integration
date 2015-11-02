class Spree::FosdickShipment < ActiveRecord::Base
  belongs_to :shipment,           class_name: 'Spree::Shipment',         foreign_key: :spree_shipment_id
  has_many   :fosdick_exceptions, class_name: 'Spree::FosdickException', foreign_key: :spree_fosdick_shipment_id

  scope :eligible_fosdick_shipments, -> { where.not(fosdick_order_num: nil).where(state: 'sent', ship_date: nil)}

  serialize :tracking_number
end
