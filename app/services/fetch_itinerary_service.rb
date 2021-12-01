require "open-uri"
require "json"

# ...

class FetchItineraryService
  def initialize(depart, arrivee)
    @depart = depart
    @arrivee = arrivee
  end

  def call
    url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-circulation-passages-tr&q=&rows=10000&sort=-arriveetheorique&facet=idligne&facet=nomcourtligne&facet=sens&facet=destination&facet=precision&geofilter.distance=#{@depart}&apikey=75c8827dffd58d7e41b4b42de99ef7de9603f4f8cb28cf4bc9746306"
    passage_serialized = URI.parse(url).open.read
    passage_depart = JSON.parse(passage_serialized)["records"]

    url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-circulation-passages-tr&q=&rows=10000&sort=-arriveetheorique&facet=idligne&facet=nomcourtligne&facet=sens&facet=destination&facet=precision&geofilter.distance=#{@arrivee}&apikey=75c8827dffd58d7e41b4b42de99ef7de9603f4f8cb28cf4bc9746306"
    passage_serialized = URI.parse(url).open.read
    passage_arrivee = JSON.parse(passage_serialized)["records"]

    id_pd = passage_depart.map do |passage|
      passage["fields"]["idcourse"]
    end

    id_pa = passage_arrivee.map do |passage|
      passage["fields"]["idcourse"]
    end

    courses = id_pd & id_pa

    relevant_pa = courses.map do |idcourse|
      passage_arrivee.find do |passage|
        passage["fields"]["idcourse"] == idcourse
      end
    end.reject(&:nil?)

    relevant_pa.sort_by! { |pd|
      Time.parse(pd["fields"]["arrivee"])
    }


    relevant_pa.map do |passagea|
      passaged = passage_depart.find { |passage_d| passage_d["fields"]["idcourse"] == passagea["fields"]["idcourse"] }

      next if Time.parse(passaged['fields']['arrivee']) > Time.parse(passagea['fields']['arrivee'])
      next if Time.parse(passaged["fields"]["arrivee"]).localtime("+01:00") < Time.now

      url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-circulation-passages-tr&q=&rows=-1&sort=-arrivee&refine.idcourse=#{passagea['fields']['idcourse']}&apikey=75c8827dffd58d7e41b4b42de99ef7de9603f4f8cb28cf4bc9746306"
      passage_serialized = URI.parse(url).open.read
      all_stops = JSON.parse(passage_serialized)["records"]

      departure_stop_index = all_stops.find_index {|stop| stop["fields"]["nomarret"] == passaged['fields']['nomarret']}
      arrival_stop_index = all_stops.find_index {|stop| stop["fields"]["nomarret"] == passagea['fields']['nomarret']}

      coordinates = ""
      all_stops.each_with_index do |stop, index|
        if (departure_stop_index..arrival_stop_index).to_a.include?(index)
          coordinates += "#{stop["fields"]["coordonnees"].join(",")};"
        end
      end

      {
        bus_id: passagea['fields']['idbus'],
        bus_name: passagea['fields']['nomcourtligne'],
        starting_point: passaged['fields']['nomarret'],
        end_point: passagea['fields']['nomarret'],
        departing_time: passaged['fields']['arrivee'],
        arrival_time: passagea['fields']['arrivee'],
        star_line_id: passagea['fields']['idligne'],
        star_destination: passagea['fields']['destination'],
        coordinates: coordinates
      }
    end.reject(&:nil?).first(3)

    # puts "Vos résultats de recherche :"
    # puts ""
    # results.each_with_index do |result, index|
    #   nomline = result['fields']['nomcourtligne']

    #   timea = Time.parse(result['fields']['arrivee']).localtime("+01:00")
    #   noma = result["fields"]["nomarret"]

    #   passaged = passage_depart.find { |passage| passage["fields"]["idcourse"] == result["fields"]["idcourse"] }
    #   nomd = passaged["fields"]["nomarret"]
    #   timed = Time.parse(passaged['fields']['arrivee']).localtime("+01:00")

    #   duration = (timea - timed.to_i) / 60

    #   puts "#{index + 1} #{nomline} : #{nomd} - #{timed.strftime('%Hh%M')}   ---->    #{noma} - #{timea.strftime('%Hh%M')}   (#{result["fields"]["idbus"]})"
    # end

  end
end

# Bus.find_or_create_by(
  #   idbus: idbus
  #

  # url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-vehicules-geoposition-suivi-new-billetique-tr&q=53&sort=-nomcourtligne&facet=numerobus&facet=voiturekr&facet=nomcourtligne&facet=sens&facet=destination&facet=is_nouvelle_billettique&refine.numerobus=#{bus_id}"
  # passage_serialized = URI.parse(url).open.read
# bus_star = JSON.parse(passage_serialized)["records"]['fields']

# bus_id: result['fields']['idligne']
