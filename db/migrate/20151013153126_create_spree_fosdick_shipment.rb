class CreateSpreeFosdickShipment < ActiveRecord::Migration
  def change
    create_table :spree_fosdick_shipments do |t|
      t.belongs_to :spree_shipment
      t.string     :fosdick_order_num
      t.string     :external_order_num
      t.text       :tracking_number
      t.string     :state
      t.boolean    :confirmation_sent, default: false, null: false

      t.datetime   :ship_date
      t.timestamps
    end

    add_index       :spree_fosdick_shipments, :spree_shipment_id
  end
end
