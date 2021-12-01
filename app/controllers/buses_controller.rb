class BusesController < ApplicationController
  def show
  end

  def update
    @bus = Bus.find(params[:id])
    @bus.update(status_params)
    @image_thief = thief()
    @image_agent = agent()
    @image_speaker = speaker()
    @image_garbage = garbage()
    @image_people = people()
    @image_nose = nose()

    respond_to do |format|
      format.html
      format.text { render partial: "buses/status", formats: [:html], locals: { bus: @bus, image_garbage: @image_garbage, image_thief: @image_thief, image_speaker: @image_speaker, image_nose: @image_nose, image_people: @image_people, image_agent: @image_agent } }
    end
  end

  private

  def status_params
    params.require(:bus).permit(:cleanliness_level, :safetiness, :noise_level, :bad_smell_level, :crowd_level, :agent)
  end
end
