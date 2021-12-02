require "open-uri"
require "json"

# ...

class FetchItineraryService
  def initialize(depart, arrivee)
    @depart = depart
    @arrivee = arrivee
  end

  def call
    # GET ALL STOPS NEAR DEPARTURE
    url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-circulation-passages-tr&q=&rows=10000&sort=-arriveetheorique&facet=idligne&facet=nomcourtligne&facet=sens&facet=destination&facet=precision&geofilter.distance=#{@depart}&apikey=75c8827dffd58d7e41b4b42de99ef7de9603f4f8cb28cf4bc9746306"
    passage_serialized = URI.parse(url).open.read
    passage_depart = JSON.parse(passage_serialized)["records"]

    # GET ALL STOPS NEAR ARRIVAL
    url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-circulation-passages-tr&q=&rows=10000&sort=-arriveetheorique&facet=idligne&facet=nomcourtligne&facet=sens&facet=destination&facet=precision&geofilter.distance=#{@arrivee}&apikey=75c8827dffd58d7e41b4b42de99ef7de9603f4f8cb28cf4bc9746306"
    passage_serialized = URI.parse(url).open.read
    passage_arrivee = JSON.parse(passage_serialized)["records"]

    # GET DEPARTURE COURSE IDS
    id_pd = passage_depart.map do |passage|
      passage["fields"]["idcourse"]
    end

    # GET ARRIVAL COURSE IDS
    id_pa = passage_arrivee.map do |passage|
      passage["fields"]["idcourse"]
    end

    # GET COMMON COURSES
    courses = id_pd & id_pa

    relevant_pa = courses.map do |idcourse|
      passage_arrivee.find do |passage|
        passage["fields"]["idcourse"] == idcourse
      end
    end.reject(&:nil?)

    relevant_pa.sort_by! { |pd|
      Time.parse(pd["fields"]["arrivee"])
    }

    relevant_pa = relevant_pa.map do |passagea|
      passaged = passage_depart.find { |passage_d| passage_d["fields"]["idcourse"] == passagea["fields"]["idcourse"] }

      next if Time.parse(passaged['fields']['arrivee']) > Time.parse(passagea['fields']['arrivee'])
      next if Time.parse(passaged["fields"]["arrivee"]).localtime("+01:00") < Time.now

      # puts "Looking for Eric"

      {
        idcourse: passagea['fields']['idcourse'],
        bus_id: passagea['fields']['idbus'],
        bus_name: passagea['fields']['nomcourtligne'],
        starting_point: passaged['fields']['nomarret'],
        end_point: passagea['fields']['nomarret'],
        departing_time: passaged['fields']['arrivee'],
        arrival_time: passagea['fields']['arrivee'],
        star_line_id: passagea['fields']['idligne'],
        star_destination: passagea['fields']['destination'],
        # coordinates: coordinates.delete_suffix(";")
      }
    end.reject(&:nil?).first(3)

    relevant_pa.each do |passagea|
      puts "Looking for Eric"
      url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-circulation-passages-tr&q=&rows=-1&sort=-arrivee&refine.idcourse=#{passagea[:idcourse]}&apikey=75c8827dffd58d7e41b4b42de99ef7de9603f4f8cb28cf4bc9746306"
      passage_serialized = URI.parse(url).open.read
      all_stops = JSON.parse(passage_serialized)["records"]
      passaged = passage_depart.find { |passage_d| passage_d["fields"]["idcourse"] == passagea[:idcourse] }

      departure_stop_index = all_stops.find_index {|stop| stop["fields"]["nomarret"] == passaged['fields']['nomarret']}
      arrival_stop_index = all_stops.find_index {|stop| stop["fields"]["nomarret"] == passagea[:end_point]}

      coordinates = ""
      all_stops.each_with_index do |stop, index|
        if (departure_stop_index..arrival_stop_index).to_a.include?(index)
          coordinates += "#{stop["fields"]["coordonnees"].reverse.join(",")};"
        end
      end

      passagea[:coordinates] = coordinates.delete_suffix(";")
    end

    return relevant_pa

  end
end
