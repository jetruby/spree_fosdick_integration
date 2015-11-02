class AddFosdickAtemptAndStateSpreeShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :send_atempt,   :integer, default: 0,       null: false
    add_column :spree_shipments, :fosdick_state, :string,  default: 'ready', null: false
  end
end
