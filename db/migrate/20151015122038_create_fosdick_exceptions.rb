class CreateFosdickExceptions < ActiveRecord::Migration
  def change
    create_table :spree_fosdick_exceptions do |t|
      t.belongs_to :spree_fosdick_shipment
      t.string     :error_code
      t.string     :message
      t.string     :state

      t.datetime   :happened_at
      t.timestamps
    end

    add_index :spree_fosdick_exceptions, :spree_fosdick_shipment_id
  end
end
