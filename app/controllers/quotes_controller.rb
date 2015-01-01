class QuotesController < ApplicationController
  # require 'active_shipping'
  include ActiveMerchant::Shipping
  before_filter :audit
  respond_to :json

  def search
    @log = Log.new(params: params.to_json, url: @request)
    @log.save

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
    elsif @carrier == "USPS"
      usps = USPS.new(:login => ENV["USPS_USERNAME"])
      response = usps.find_rates(@origin, @destination, @package)
      usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      render json: usps_rates
    elsif @carrier == "FEDEX"
      fedex = FedEx.new(:login => ENV["FEDEX_LOGIN"], :password => ENV["FEDEX_PASSWORD"], key: ENV["FEDEX_KEY"], account: ENV["FEDEX_ACCOUNT"], :test => true)
      response = fedex.find_rates(@origin, @destination, @package)
      fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      render json: fedex_rates
    end

  end

  private

  def audit
    # logfile = File.open('log/development.log', 'r')
    @request = request.env["REQUEST_URI"]
    @ip = request.env["REMOTE_HOST"]
    @log = Log.new(params: params.to_json, url: @request, IP: @ip)
    @log.save
  end

end
