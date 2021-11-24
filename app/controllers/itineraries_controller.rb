class ItinerariesController < ApplicationController
  def index
    @itineraries = Itinerary.all
  end

  def show
    @itinerary = Itinerary.find(params[:id])
  end

  def favorites
  end
end
