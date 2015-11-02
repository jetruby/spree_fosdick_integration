Spree::Shipment.class_eval do
  has_one :fosdick_shipment, class_name: 'Spree::FosdickShipment', foreign_key: :spree_shipment_id, dependent: :delete

  def self.perform_fosdick_shipments
    shipments = where(shipped_at: nil, state: 'ready', send_atempt: 0..2).where.not(fosdick_state: ['duplicate', 'success'])

    #TODO: Create Serializer for

    JSON.parse(ActiveModel::ArraySerializer.new(shipments, each_serializer: MyShipmentSerializer, root: false).to_json) if shipments.present?
  end
end
