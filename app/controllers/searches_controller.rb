class SearchesController < ApplicationController

  def index
    @search = Search.new

    @search_result = TransitData.new.stops_by_route
    # TransitData.new.user_location('2601:646:c600:252f:53b:cfb5:78f1:4c42')
    # request.remote_ip
    # TransitData.new.stops_by_route
    # stops_by_route
    # next_departure_from_stop
  end

  def create
    @search = Search.new(whitelisted_search_params)
    redirect_to searches_path
  end

  def show

  end

  private

  def whitelisted_search_params
    params.require(:search).permit(:origin, :destination)
  end

end
