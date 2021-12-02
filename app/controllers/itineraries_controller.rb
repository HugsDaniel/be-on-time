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
          star_bus_id: iti[:bus_id]
        )

        bus.star_line_short_name = iti[:bus_name]
        bus.star_line_id = iti[:star_line_id]
        bus.star_destination = iti[:star_destination]

        bus.save

        @colours << Line.find_by(star_line_id: bus.star_line_id)&.colour

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

      @route = @itineraries_data.first[:coordinates] if @itineraries_data.length > 1
      
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

    @image_thief = thief()
    @image_agent = agent()
    @image_speaker = speaker()
    @image_garbage = garbage()
    @image_people = people()
    @image_nose = nose()
    @image_url = helpers.asset_url('bus_marker3.png')

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
end