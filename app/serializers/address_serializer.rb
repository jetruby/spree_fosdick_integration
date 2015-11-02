require 'active_model/serializer'

class AddressSerializer < ActiveModel::Serializer
  attributes :firstname, :lastname, :address1, :address2, :zipcode, :city,
             :state, :country, :phone

  def country
    object.country.try(:iso)
  end

  def state
    if object.state
      object.state.abbr
    else
      object.state_name
    end
  end
end
