class ItinerariesController < ApplicationController
  def index
    if params[:departure].present? && params[:arrival].present?
      @itinerary = Itinerary.new(starting_point: params[:departure], end_point: params[:arrival])
      @itinerary.user = current_user

      @departing = Geocoder.coordinates(@itinerary.starting_point).join(",")+",200"
      @arrival = Geocoder.coordinates(@itinerary.end_point).join(",")+",200"

      @itineraries_data = FetchItineraryService.new(@departing, @arrival).call
      @colours = []

      @itineraries = @itineraries_data.map do |iti|
        bus = Bus.find_or_create_by!(
          star_bus_id: iti[:bus_id],
          star_line_short_name: iti[:bus_name],
          star_line_id: iti[:star_line_id],
          star_destination: iti[:star_destination]
        )
        @colours << Line.find_by(star_line_id: bus.star_line_id).colour

        itinerary = Itinerary.create!(
          user: current_user,
          starting_point: iti[:starting_point],
          end_point: iti[:end_point],
          departing_time: iti[:departing_time],
          arrival_time: iti[:arrival_time]
        )

        ItineraryBus.create!(
          bus: bus,
          itinerary: itinerary,
          starting_point: itinerary.starting_point,
          end_point: itinerary.end_point,
          departing_time: iti[:departing_time],
          arrival_time: iti[:arrival_time]
        )
        itinerary
      end

      @route = @itineraries_data.first[:coordinates]

    end
  end

  def show
    @itinerary = Itinerary.find(params[:id])
    # @email = @itinerary.user.email

    @iti_bus = @itinerary.itinerary_buses.first
    @bus = @iti_bus.bus
    @direction = @bus.star_destination
    @star_short_name = @bus.star_line_short_name
    @colour_line = Line.find_by(star_line_id: @bus[:star_line_id]).colour
    @image_url = helpers.asset_url('bus_marker3.png')
  end

  def favorites
  end
end
