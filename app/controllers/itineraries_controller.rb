class ItinerariesController < ApplicationController
  def index
    if params[:departure].present? && params[:arrival].present?
      @itinerary = Itinerary.new(starting_point: params[:departure], end_point: params[:arrival])
      @itinerary.user = current_user

      # from = Geocoder.coordinates(@itinerary.starting_point)
      # to = Geocoder.coordinates(@itinerary.end_point)

      # @departing = BusStop.near(from, 1.5, order: :distance).first
      # @arrival = BusStop.near(to, 1.5, order: :distance).first
      @departing = @itinerary[:starting_point]
      @arrival = @itinerary[:end_point]

      @itineraries_data = FetchItineraryService.new(@departing, @arrival).call

      @itineraries = @itineraries_data.map do |iti|
        bus = Bus.find_or_create_by!(
          star_bus_id: iti[:bus_id],
          star_line_short_name: iti[:bus_name]
        )

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

    end
  end



  def show
    @itinerary = Itinerary.find([:id])
  end

  def favorites
  end
end
