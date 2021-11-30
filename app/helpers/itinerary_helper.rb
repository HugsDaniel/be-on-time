module ItineraryHelper
  def arrives_after(departing_time)
    (departing_time.localtime("+01:00") - Time.now).to_i / 60
  end

  def trip_time(arrival_time)
    (arrival_time.localtime("+01:00") - Time.now).to_i / 60
  end
end
