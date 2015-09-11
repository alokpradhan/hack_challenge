require 'sfba_transit_api'

class TransitData

attr_accessor :user_address

include HTTParty
include Geocoder

def initialize(ip=nil, start_address=nil, destination=nil)
  @client = SFBATransitAPI.client ENV['511_SECURITY_TOKEN']
  user_location(ip)
end

def user_location(ip)
  @user_coordinates = Geocoder.coordinates(ip)
  @user_address = Geocoder.address(@user_coordinates)
end

def agencies
  agency_names = []
  @client.get_agencies.each do |agency|
    agency_names.push(agency['name'])
  end
  [agency_names[0]]  # limiting to first agency to not exceed Geocoding limit
end

def routes_by_agency(agency)
  @client.get_routes_for_agency(agency)[0]['routes']
end

def stops_by_route(agency, code, direction=false)
  options = { agency_name: agency,
              route_code: code,
              route_direction_code: direction
            }
  if direction
    @client.get_stops_for_route(options)[0]["routes"][0]["route_directions"][0]["stops"]
  else
    @client.get_stops_for_route(options)[0]["routes"][0]["stops"]
  end
end

def next_departure_from_stop(direction=false)
  if direction
    @client.get_next_departures_by_stop_code('23')[0]["routes"][0]["route_directions"][0]["stops"][0]["departure_times"]
  else
    @client.get_next_departures_by_stop_code('23')[0]["routes"][0]["stops"][0]["departure_times"]
  end
end

def next_departures(agency, stop)

end

def nearby_stops
  nearby_stops = []
  Stop.all.each do |specific_stop|
    stop_minutes = specific_stop.latitute + specific_stop.longitude
    user_minutes = @user_coordinates[0] + @user_coordinates[1]
    distance = (stop_minutes - user_minutes).abs
    distance = Geocoder::Calculations.distance_between(stop_coordinates, @user_coordinates)
    if distance < 0.01  # 0.01 degrees ~ 0.6 nautical miles
      nearby_stops.push(specific_stop)
    end
  end
  nearby_stops
end

def populate_stops
  agency_names = agencies
  agency_names.each do |agency|
    routes_by_agency(agency).each do |route|
      route_code = route['code']
      if route['route_directions']
        route['route_directions'].each do |direction|
          direction_code = route['route_directions'][0]['code']
          stops_by_route(agency, route_code, direction_code).each do |stop|
            create_stop(agency, route_code, stop, direction_code)
          end
        end
      else
        stops_by_route(agency, route_code).each do |stop|
          create_stop(agency, route_code, stop)
        end
      end
    end
  end
end

def create_stop(agency, route_code, transit_stop, direction='NA')
  stop_to_add = Stop.new
  stop_to_add.agency = agency
  stop_to_add.direction = direction
  stop_to_add.route_code = route_code
  stop_to_add.name = transit_stop['name']
  stop_to_add.code = transit_stop['stop_code']
  # stop_coordinates = Geocoder.coordinates(transit_stop['name'])
  # stop_to_add.latitute = stop_coordinates[0].to_f
  # stop_to_add.longitude = stop_coordinates[1].to_f
  stop_to_add.save
end

end
