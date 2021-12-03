class ItinerariesController < ApplicationController
  def index
    if params[:departure].present? && params[:arrival].present?
      @itinerary = Itinerary.new(starting_point: params[:departure], end_point: params[:arrival])
      @itinerary.user = current_user

      @departing = Geocoder.coordinates(@itinerary.starting_point).join(",")+",500"
      @arrival = Geocoder.coordinates(@itinerary.end_point).join(",")+",500"

      @itineraries_data = FetchItineraryService.new(@departing, @arrival).call
      @colours = []

      @itineraries = @itineraries_data.map do |iti|

        bus = Bus.find_or_create_by!(
          star_bus_id: iti[:bus_id]
        )

        bus.star_line_short_name = iti[:bus_name]
        bus.star_line_id = iti[:star_line_id]
        bus.star_destination = iti[:star_destination]

        bus.save

        itinerary = Itinerary.create!(
          user: current_user,
          starting_point: iti[:starting_point],
          end_point: iti[:end_point],
          departing_time: iti[:departing_time],

          arrival_time: iti[:arrival_time],
          route: iti[:coordinates],
          colour: Line.find_by(star_line_id: bus.star_line_id)&.colour || "#47B1FF"
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
        # @itinerary = Itinerary.find(params[:id])
        # @iti_bus = @itinerary.itinerary_buses.first
        # @bus = @iti_bus.bus
        # @direction = @bus.star_destination
        # @star_short_name = @bus.star_line_short_name

      end
      @dep_coordinates = Geocoder.coordinates(params[:departure])
      @ari_coordinates = Geocoder.coordinates(params[:arrival])


      @markers = [
        {
          lat: @dep_coordinates.first,
          lng: @dep_coordinates.last,
          image_url: helpers.asset_url('starting_point.svg')
        },
        {
          lat: @ari_coordinates.first,
          lng: @ari_coordinates.last,
          image_url: helpers.asset_url('end_point.svg')
        }
      ]

      # @route = @itineraries_data.first[:coordinates] if @itineraries_data.length > 1
    end
  end

  def show
    @itinerary = Itinerary.find(params[:id])

    @starting_point = @itinerary.route.split(";").first.split(",").map(&:to_f)
    @end_point = @itinerary.route.split(";").last.split(",").map(&:to_f)

    # @starting_point = BusStop.find_by(name: @itinerary.starting_point)
    # @end_point = BusStop.find_by(name: @itinerary.end_point)

    if @starting_point && @end_point
      @markers = [
        {
          lng: @starting_point.first,
          lat: @starting_point.last,
          image_url: helpers.asset_url('starting_point.svg')
        },
        {
          lng: @end_point.first,
          lat: @end_point.last,
          image_url: helpers.asset_url('end_point.svg')
        },
      ]
    end
    # @email = @itinerary.user.email

    @iti_bus = @itinerary.itinerary_buses.first
    @bus = @iti_bus.bus

    @route_geo = build_approaching_route(@bus, @starting_point)

    @direction = @bus.star_destination
    @star_short_name = @bus.star_line_short_name
    @colour_line = Line.find_by(star_line_id: @bus[:star_line_id]).colour

    @image_thief = thief()
    @image_agent = agent()
    @image_speaker = speaker()
    @image_garbage = garbage()
    @image_people = people()
    @image_nose = nose()
    @image_url = helpers.asset_url('bus_marker3.png')

  end

  def mark_as_favorite
    @itinerary = Itinerary.find(params[:id])
    @itinerary.favorite = !@itinerary.favorite
    @itinerary.save

    respond_to do |format|
      format.html
      format.text { render partial: "itineraries/favorite", locals: { itinerary: @itinerary }, formats: [:html] }
    end
  end

  def favorites
    @itineraries_fav = Itinerary.where(favorite: true).to_a




    @colours =[]
    @itineraries = @itineraries_fav.map.with_index do |itinerary, index|
      @departing = Geocoder.coordinates(itinerary.starting_point).join(",")+",400"
      @arrival = Geocoder.coordinates(itinerary.end_point).join(",")+",400"

      @itineraries_data = FetchItineraryService.new(@departing, @arrival).call
      iti = @itineraries_data.first
      @bus = Bus.find(itinerary.bus_ids[0])
      if Line.where(:star_line_id => @bus.star_line_id).first
        @colours << Line.find_by(star_line_id: @bus.star_line_id).colour
      else
        @colours << "#47B1FF"
      end

      @bus.star_line_short_name = iti[:bus_name]
      itinerary.update(
        user: current_user,
        departing_time: iti[:departing_time],
        arrival_time: iti[:arrival_time]
      )
      itinerary.itinerary_buses.update(
        bus: @bus,
        itinerary: itinerary,
        starting_point: itinerary.starting_point,
        end_point: itinerary.end_point,
        departing_time: iti[:departing_time],
        arrival_time: iti[:arrival_time]
      )

    end
  end

  private

  def build_approaching_route(bus, starting_point)
    url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-vehicules-position-tr&q=&sort=idbus&facet=numerobus&facet=nomcourtligne&facet=sens&facet=destination&refine.idbus=#{bus.star_bus_id}&apikey=75c8827dffd58d7e41b4b42de99ef7de9603f4f8cb28cf4bc9746306"
    bus_ser = URI.parse(url).open.read
    bus_position = JSON.parse(bus_ser)["records"].first["fields"]["coordonnees"]

    coordinates = "#{bus_position.last},#{bus_position.first};#{starting_point.first},#{starting_point.last}"

    url = "https://api.mapbox.com/optimized-trips/v1/mapbox/walking/#{coordinates}?roundtrip=false&destination=last&overview=full&steps=true&geometries=geojson&source=first&access_token=#{ENV["MAPBOX_API_KEY"]}"
    trip_ser = URI.parse(url).open.read
    trip_data = JSON.parse(trip_ser)


    return trip_data["trips"].first["geometry"]
  end

end
