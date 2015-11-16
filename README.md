# SpreeFosdickIntegration

Current gem provides easy integration for you Spree Commerce based apps with full service fulfillment services of Fosdick Fulfillment.

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
Update ``` config/fosdick.yml ``` with your credentials received from Fosdick

## Usage
Create a rake task to push shipments to Fosdick iPost interface:

```
desc "Push shipments to Fosdick iPost interface"
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

```
desc "Receive shipment information from Fosdick API"
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

Override the email view to customise:

```
app/views/spree/fosdick_shipment_mailer/order_shipped.html.erb
```

##Testing

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_fosdick_integration/factories'
```
