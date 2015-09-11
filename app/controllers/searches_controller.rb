class SearchesController < ApplicationController

  def index
    @search = Search.new
    transit = TransitData.new('2601:646:c600:252f:53b:cfb5:78f1:4c42')
    @search_result = TransitData.new.next_departure_from_stop
    # transit.stop_coordinates
    # .stop_coordinates
    # TransitData.new.stops_by_route('AC Transit', '1', 'South')[0]['stop_code']
    # TransitData.new.populate_stops
    # TransitData.new.user_location('2601:646:c600:252f:53b:cfb5:78f1:4c42')
    # request.remote_ip
    # TransitData.new.stops_by_route
    # stops_by_route
    # next_departure_from_stop
  end

  def create
    @search = Search.new(whitelisted_search_params)

    respond_to do |format|
      if @search.save
        flash[:success] = "Searched"
        format.html {redirect_to  searches_path}
        format.js
      else
        flash[:error] = "Unable to search"
        format.html {redirect_to searches_path}
        format.js {redirect_to searches_path}
      end
    end
  end


  def show

  end

  private

  def whitelisted_search_params
    params.require(:search).permit(:origin, :destination, :agency, :stop)
  end

end
