class QuotesController < ApplicationController
  # require 'active_shipping'
  include ActiveMerchant::Shipping

  def search
    
    @package = Package.new(12,
                          [93,10],
                          :cylinder => false
                          )

    @origin = Location.new(:country => params["origincountry"],
                           :state => params["originstate"],
                           :city => params["origincity"],
                           :zip => params["originzip"]
                           )

    @destination = Location.new(:country => params["country"],
                                :state => params["state"],
                                :city => params["city"],
                                :zip => params["zip"]
                                )

    @carrier = params["carrier"]

    if @carrier == "UPS"
      ups = UPS.new(:login => ENV["UPS_LOGIN"], :password => ENV["UPS_PASSWORD"], :key => ENV["UPS_ACCESS_KEY"])
      response = ups.find_rates(@origin, @destination, @package)
      ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      render json: ups_rates
    end

    # http://localhost:3000/quotes/search?origincountry=US&originstate=WA&origincity=Seattle&originzip=98121&country=US&state=MD&city=Baltimore&zip=21231&carrier=UPS

    # @package = Package.new(  100,                        # 100 grams
    #   [93,10],                    # 93 cm long, 10 cm diameter
    #   :cylinder => true)         # cylinders have different volume calculations
    #
    # @origin = Location.new(      :country => 'US',
    # :state => 'CA',
    # :city => 'Beverly Hills',
    # :zip => '90210')
    #
    # @destination = Location.new( :country => 'CA',
    # :province => 'ON',
    # :city => 'Ottawa',
    # :postal_code => 'K1P 1J1')
    #

    # usps = USPS.new(:login => ENV["USPS_USERNAME"])
    # response = usps.find_rates(@origin, @destination, @package)
    # render json: response

    # fedex = FedEx.new(:login => ENV["FEDEX_LOGIN"], :password => ENV["FEDEX_PASSWORD"], key: ENV["FEDEX_KEY"], account: ENV["FEDEX_ACCOUNT"], :test => true)
    # tracking_info = fedex.find_tracking_info('111111111111', :carrier_code => 'fedex_ground') # Ground package
    # tracking_info.shipment_events.each do |event|
    #   puts "#{event.name} at #{event.location.city}, #{event.location.state} on #{event.time}. #{event.message}"
    # end
    # render json: tracking_info

  end
end
