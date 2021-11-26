require "open-uri"
require "json"

# ...

class FetchItineraryService
  def initialize(depart, arrivee)
    @depart = depart
    @arrivee = arrivee
  end

  def call
    url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-circulation-passages-tr&q=&sort=-departtheorique&refine.nomarret=#{@depart}"
    passage_serialized = URI.parse(URI.escape(url)).open.read
    passage_depart = JSON.parse(passage_serialized)["records"]

    url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-circulation-passages-tr&q=&sort=-departtheorique&refine.nomarret=#{@arrivee}"
    passage_serialized = URI.parse(URI.escape(url)).open.read
    passage_arrivee = JSON.parse(passage_serialized)["records"]

    id_pd = passage_depart.map do |passage|
      passage["fields"]["idcourse"]
    end

    id_pa = passage_arrivee.map do |passage|
      passage["fields"]["idcourse"]
    end

    courses = id_pd & id_pa

    relevant_pa = courses.map do |idcourse|
      passage_arrivee.find { |passage| passage["fields"]["idcourse"] == idcourse }
    end

    relevant_pa.sort_by! { |pd|
      Time.parse(pd["fields"]["arrivee"])
    }

    results = relevant_pa


    results.map do |result|
      passaged = passage_depart.find { |passage| passage["fields"]["idcourse"] == result["fields"]["idcourse"] }

      next if Time.parse(passaged['fields']['arrivee']) > Time.parse(result['fields']['arrivee'])

      {
        bus_id: result['fields']['idbus'],
        bus_name: result['fields']['nomcourtligne'],
        starting_point: @depart,
        end_point: @arrivee,
        departing_time: Time.parse(passaged['fields']['arrivee']).localtime("+01:00"),
        arrival_time: Time.parse(result['fields']['arrivee']).localtime("+01:00"),
        star_line_id: result['fields']['idligne'],
        star_destination: result['fields']['destination']
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
  # )

  # url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-vehicules-geoposition-suivi-new-billetique-tr&q=53&sort=-nomcourtligne&facet=numerobus&facet=voiturekr&facet=nomcourtligne&facet=sens&facet=destination&facet=is_nouvelle_billettique&refine.numerobus=#{bus_id}"
  # passage_serialized = URI.parse(url).open.read
# bus_star = JSON.parse(passage_serialized)["records"]['fields']

# bus_id: result['fields']['idligne']
