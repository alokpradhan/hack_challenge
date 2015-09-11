require 'sfba_transit_api'

class TransitData

include HTTParty

include Geocoder

# base_uri 'services.my511.org'

def initialize
  @client = SFBATransitAPI.client ENV['511_SECURITY_TOKEN']
  @results = {}
  @user_address
end

def agencies
  # parameters = { query: { token: ENV['511_SECURITY_TOKEN'] } }
  # self.class.get('/Transit2.0/GetAgencies.aspx', parameters)

  @client.get_agencies

end

def routes_by_agency
  # parameters = { query: {
  #   token: ENV['511_SECURITY_TOKEN'],
  #   agencyNames:'BART'
  #   }
  # }
  # self.class.get('/Transit2.0/GetRoutesForAgencies.aspx', parameters)

  @client.get_routes_for_agencies(['BART', 'AC Transit', 'Caltrain', 'Dumbarton Express', 'Marin Transit'])

end

def stops_by_route
  options = { agency_name: 'BART',
              route_code: '747',
              route_direction_code: 'South'
            }
  @client.get_stops_for_route(options)[0]["routes"][0]["stops"]
  # [0]["routes"][0]["route_directions"][0]["stops"]
end

def next_departure_from_stop
  @client.get_next_departures_by_stop_code('23')[0]["routes"][0]["stops"][0]["departure_times"]
  # [0]["routes"][0]["route_directions"][0]["stops"][0]["departure_times"]
end

def user_location(ip)
  coordinates = Geocoder.coordinates(ip)
  @user_address = Geocoder.address(coordinates)
end

def stop_coordinates(stop)
end

def populate_stops

end


end

# 1. Get stop code and name
# 2. Get stop coordinates
# 3. Find distance between current location and stop coordinates
# 4.
