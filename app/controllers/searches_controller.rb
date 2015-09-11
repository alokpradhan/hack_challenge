class SearchesController < ApplicationController

  def index
    @search = Search.new
    @search_result = TransitData.new.next_departure_from_stop
  end

  def create
    @search = Search.new(whitelisted_search_params)

    transit = TransitData.new(request.remote_ip)
    agency = params[:agency]
    stop = params[:stop]

    @search_result = transit.next_departures(agency, stop)
    redirect_to searches_path

    # respond_to do |format|
    #   if @search.save
    #     flash[:success] = "Searching"
    #     format.html {redirect_to searches_path}
    #     format.js
    #   else
    #     flash[:error] = "Unable to search"
    #     format.html {redirect_to searches_path}
    #     format.js {redirect_to searches_path}
    #   end
    # end
  end

  def show
  end

  private

  def whitelisted_search_params
    params.require(:search).permit(:origin, :destination, :agency, :stop)
  end

end
