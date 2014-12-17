class QuotesController < ApplicationController

  def search
    # Package up a poster and a Wii for your nephew.
    packages = [
      Package.new(  100,                        # 100 grams
      [93,10],                    # 93 cm long, 10 cm diameter
      :cylinder => true),         # cylinders have different volume calculations

      Package.new(  (7.5 * 16),                 # 7.5 lbs, times 16 oz/lb.
      [15, 10, 4.5],              # 15x10x4.5 inches
      :units => :imperial)        # not grams, not centimetres
    ]

    origin = Location.new(      :country => 'US',
    :state => 'CA',
    :city => 'Beverly Hills',
    :zip => '90210')

    destination = Location.new( :country => 'CA',
    :province => 'ON',
    :city => 'Ottawa',
    :postal_code => 'K1P 1J1')

    ups = UPS.new(:login => ENV["UPS_LOGIN"], :password => ENV["UPS_PASSWORD"], :key => ENV["UPS_ACCESS_KEY"])
    response = ups.find_rates(origin, destination, packages)
    render.json { response }
  end
end
