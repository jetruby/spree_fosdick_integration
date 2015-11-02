Deface::Override.new(
  virtual_path: 'spree/admin/orders/index',
  name: 'admin_fosdick_index_button',
  insert_before: "erb[silent]:contains('if can? :edit, Spree::Order.new ')",
  text: "<li style='padding-right: 5px;'>
           <%= button_link_to 'Fosdick panel', admin_fosdick_shipments_path, icon: '', id: 'admin_fosdick_index' %>
         </li>"
)
