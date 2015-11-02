# SpreeFosdickIntegration

TODO: Write a gem description

##Installation

Add this line to your application's Gemfile:

```ruby
gem 'spree_fosdick_integration'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_fosdick_integration:install
```

## Usage
Create a rake task to push shipments to Fosdick iPost interface:

```desc "Push shipments to Fosdick iPost interface"
task push_shipments_fosdick: :environment do
  eligible_shipments = Spree::Shipment.perform_fosdick_shipments

  if eligible_shipments.present?
    eligible_shipments.each do |shipment|
      Fosdick::Processor.send_shipment(shipment, FOSDICK_CONFIG)
    end
  end
end
```

Create a rake task to receive shipment information from Fosdick API:

```desc "Receive shipment information from Fosdick API"
task receive_shipments_fosdick: :environment do
  eligible_shipments = Spree::FosdickShipment.eligible_fosdick_shipments

  if eligible_shipments.present?
    eligible_shipments.each do |fosdick_shipment|
      # get tracking details
      Fosdick::Processor.receive_shipment({external_order_num: fosdick_shipment.external_order_num }) if fosdick_shipment.tracking_number.nil?
      # get ship_date
      Fosdick::Processor.receive_shipment({external_order_num: fosdick_shipment.external_order_num }, 'shipments.json') if fosdick_shipment.ship_date.nil?
    end
  end
end
```

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/spree_fosdick_integration/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
