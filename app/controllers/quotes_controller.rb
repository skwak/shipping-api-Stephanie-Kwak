class QuotesController < ApplicationController
  require 'active_shipping'
  include ActiveMerchant::Shipping
  
  def search
    # Package up a poster and a Wii for your nephew.

      @package = Package.new(  100,                        # 100 grams
      [93,10],                    # 93 cm long, 10 cm diameter
      :cylinder => true)         # cylinders have different volume calculations

    @origin = Location.new(      :country => 'US',
    :state => 'CA',
    :city => 'Beverly Hills',
    :zip => '90210')

    @destination = Location.new( :country => 'CA',
    :province => 'ON',
    :city => 'Ottawa',
    :postal_code => 'K1P 1J1')

    ups = UPS.new(:login => ENV["UPS_LOGIN"], :password => ENV["UPS_PASSWORD"], :key => ENV["UPS_ACCESS_KEY"])
    response = ups.find_rates(@origin, @destination, @package)
    render json: response
  end
end
