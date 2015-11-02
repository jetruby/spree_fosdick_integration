class Spree::FosdickException < ActiveRecord::Base
  belongs_to :fosdick_shipment, class_name: 'Spree::FosdickShipment', foreign_key: :spree_fosdick_shipment_id

  after_create :update_shipment_fosdick_state

  def shipment
    self.fosdick_shipment.shipment
  end

  private

  def update_shipment_fosdick_state
    self.shipment.update_column(:fosdick_state, "#{message.include?('Duplicate') ? 'duplicate' : 'exception'}")
  end
end
