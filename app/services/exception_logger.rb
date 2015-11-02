class ExceptionLogger

  def log(code, message, instance_id)
    # Include notification logic if needed
    unless Spree::FosdickException.find_by(spree_fosdick_shipment_id: instance_id, error_code: code).present?
      Spree::FosdickException.create! build_fosdick_exception_attributes(code, message, instance_id)
    end
  end

  private

  def build_fosdick_exception_attributes(code, message, instance_id)
    {
      spree_fosdick_shipment_id: instance_id,
      error_code: code,
      message: message,
      state: 'error',
      happened_at: Time.now.in_time_zone
    }
  end
end
