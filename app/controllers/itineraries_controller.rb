class ItinerariesController < ApplicationController
  def index
    # itinerary = Itinerary.new(itinerary_params)
    @itinerary = Itinerary.new(starting_point: params[:departure], end_point: params[:arrival])
    @itinerary.user = current_user
    from = Geocoder.coordinates(@itinerary.starting_point)
    to = Geocoder.coordinates(@itinerary.end_point)
    departing = BusStop.near(from, 1.5, order: :distance)
    arrival = BusStop.near(to, 1.5, order: :distance)

    @options = departing.map(&:route) & arrival.map(&:route)

    # @bus_lines = options.map(&:line).first(2)


    @itineraries = Itinerary.all

  end

  def show
    @itinerary = Itinerary.find([:id])
  end

  def favorites
  end

  private

  # def itinerary_params
  #   params.require(:itinerary).permit(:starting_point, :end_point, :departing_time, :arrival_time)
  # end
end
