class BusesController < ApplicationController
  def show
  end

  def update
    @bus = Bus.find(params[:id])
    @bus.update(status_params)
  end

  private

  def status_params
    params.require(:bus).permit(:cleanliness_level, :safetiness, :noise_level, :bad_smell_level, :crowd_level, :agent)
  end
end
