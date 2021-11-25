class ItinerariesController < ApplicationController
  def index
    @itineraries = Itinerary.all
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    # @email = @itinerary.user.email

        iti_bus = @itinerary.itinerary_buses.first
        @bus= iti_bus.bus
        @direction = @bus.star_destination
        @star_short_name = iti_bus.bus.line.star_short_name
        @colour_line = iti_bus.bus.line.colour





  end

  def favorites
  end
end
