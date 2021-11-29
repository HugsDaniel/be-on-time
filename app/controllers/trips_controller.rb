class TripsController < ApplicationController
  def show
    @itinerary = Itinerary.find(params[:id])
    iti_bus = @itinerary.itinerary_buses.first
    @bus = iti_bus.bus
    @direction = @bus.star_destination
    @star_short_name = @bus.star_line_short_name
    @colour_line = Line.find_by(star_line_id: @bus[:star_line_id]).colour
    @image_thief = thief()
    @image_agent = agent()
    @image_speaker = speaker()
    @image_garbage = garbage()
    @image_people = people()
    @image_nose = nose()
  end
end
