class TripsController < ApplicationController
  def show
    @itinerary = Itinerary.find(params[:id])
    @bus = Bus.find(16)
  end
end
