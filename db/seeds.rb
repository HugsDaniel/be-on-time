# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
require 'open-uri'
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

print "Cleaning DB..."
ItineraryBus.destroy_all
Itinerary.destroy_all
Bus.destroy_all
BusStop.destroy_all
Route.destroy_all
Line.destroy_all
User.destroy_all
puts "Done !"


print "Creating users..."
user = User.create!(email: "paula@example.com", password: "123456")
user_two = User.create!(email: "hugo@example.com", password: "123456")
user_three = User.create!(email: "stan@example.com", password: "123456")
user_four = User.create!(email: "four@example.com", password: "123456")
user_five = User.create!(email: "five@example.com", password: "123456")
user_six = User.create!(email: "six@example.com", password: "123456")
user_seven = User.create!(email: "seven@example.com", password: "123456")
user_eight = User.create!(email: "eight@example.com", password: "123456")
user_nine = User.create!(email: "nine@example.com", password: "123456")
user_ten = User.create!(email: "ten@example.com", password: "123456")
user_eleven = User.create!(email: "eleven@example.com", password: "123456")
user_twelve = User.create!(email: "twelve@example.com", password: "123456")
user_thirteen = User.create!(email: "thirteen@example.com", password: "123456")
user_fourteen = User.create!(email: "fourteen@example.com", password: "123456")
user_fifteen = User.create!(email: "fifteen@example.com", password: "123456")
puts "Done !"

# create lines

api_url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-topologie-lignes-td&q=&rows=-1&sort=id&facet=nomfamillecommerciale"
serialized_data = URI.parse(api_url).open.read
results = JSON.parse(serialized_data)['records']

puts "Number of lines in Star API : #{results.count}"

print "Creating Lines..."
results.each do |result|
  print "."
  Line.create!(
    star_line_id: result['fields']['id'].to_i,
    star_short_name: result['fields']['nomcourt'],
    star_long_name: result['fields']['nomlong'],
    colour: result['fields']['couleurligne']
  )
end
puts "Done !"


# create routes
api_two_url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-topologie-parcours-td&q=&rows=-1&sort=idligne&facet=idligne&facet=nomcourtligne&facet=senscommercial&facet=type&facet=nomarretdepart&facet=nomarretarrivee&facet=estaccessiblepmr"
serialized_data_two = URI.parse(api_two_url).open.read
results_two = JSON.parse(serialized_data_two)['records']

puts "Number of routes in Star API : #{results_two.count}"

print "Creating Routes..."
results_two.each do |result|
  print "."
  route = Route.new(
    route_json: result['fields']['parcours']['coordinates'].to_json,
    star_route_id: result['fields']['id'],
    star_line_id: result['fields']['idligne'].to_i,
    star_direction_code: result['fields']['sens'].to_i,
    departure_stop: result['fields']['nomarretdepart'],
    arrival_stop: result['fields']['nomarretarrivee']
  )

  route.line = Line.find_by(star_line_id: result['fields']['idligne'])
  route.save!
end
puts "Done !"

# create bus_stops
# Page with info of stops name associated to a route
api_three_url = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-topologie-dessertes-td&q=&rows=-1&sort=idparcours&facet=libellecourtparcours&facet=nomcourtligne&facet=nomarret&facet=estmonteeautorisee&facet=estdescenteautorisee"
serialized_data_three = URI.parse(api_three_url).open.read
results_three = JSON.parse(serialized_data_three)['records']

puts "Number of bus stops in Star API : #{results_three.count}"

# Page with info of the coordinates of each stop
url_coord = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-topologie-pointsarret-td&q=&rows=-1&sort=nom&facet=nom&facet=codeinseecommune&facet=nomcommune&facet=estaccessiblepmr&facet=mobilier"
get_data = URI.parse(url_coord).open.read
stops_coord = JSON.parse(get_data)['records']

print "Creating bus stops"
results_three.each do |result|
  print "."
  bus_stop = BusStop.new(
    name: result['fields']['nomarret'],
  )
  stop_id = result['fields']['idarret']
  stop = stops_coord.find { |stop| stop["fields"]["id"] == stop_id }
  bus_stop.longitude = stop["fields"]["coordonnees"][1].to_f
  bus_stop.latitude = stop["fields"]["coordonnees"][0].to_f

  bus_stop.route = Route.find_by(star_route_id: result['fields']['idparcours'])

  bus_stop.save
end
puts "Done !"

# Create buses

url_geo_bus = "https://data.explore.star.fr/api/records/1.0/search/?dataset=tco-bus-vehicules-geoposition-suivi-new-billetique-tr&q=&rows=-1&sort=idbus&facet=numerobus&facet=voiturekr&facet=nomcourtligne&facet=sens&facet=destination&facet=is_nouvelle_billettique"
buses_data = URI.parse(url_geo_bus).open.read
buses = JSON.parse(buses_data)['records']

puts "Number of buses in Star API : #{buses.count}"

print "Creating buses"
buses.each do |bus|
  print "."
  new_bus = Bus.new(
    star_bus_id: bus['fields']['idbus'].to_i,
    star_destination: bus['fields']['destination'],
    star_line_short_name: bus['fields']['nomcourtligne'],
    star_longitude: bus['fields']['coordonnees'][1].to_f,
    star_latitude: bus['fields']['coordonnees'][0].to_f,
    star_line_id: bus['fields']['idligne'].to_i,
    star_direction_code: bus['fields']['sens'].to_i
  )
#   new_bus.route = Route.find_by(star_line_id: bus['fields']['idligne'], arrival_stop: bus['fields']['destination'])
#   new_bus.line = Line.find_by(star_line_id: bus['fields']['idligne'])
  new_bus.save!
end
puts "Done !"

bus_53 = Bus.new(
  star_bus_id: -1006393600,
  star_destination: "République",
  star_line_short_name: "53",
  star_longitude: -1.753324,
  star_latitude: 48.119246,
  star_line_id: 0053,
  star_direction_code: 0
  )
# bus_53.route = Route.find_by(star_route_id: "0053-B-4267-1167")
# bus_53.line = Line.find_by(star_line_id: "53")
bus_53.save!

bus_157 = Bus.new(
  star_bus_id: -1006393600,
  star_destination: "Bruz Centre",
  star_line_short_name: "157ex",
  star_longitude: -1.679767,
  star_latitude: 48.109326,
  star_line_id: 0157,
  star_direction_code: 0
)
# bus_157.route = Route.find_by(star_route_id: "0157-A-1501-2361")
# bus_157.line = Line.find_by(star_line_id: "157ex")
bus_157.save!

# Create itineraries

print "Creating itineraries"

itinerary = Itinerary.new(
  starting_point: "2 Square de la Fée Viviane 35000 Rennes",
  end_point: "Republique 35000 Rennes",
  favorite: true
)

itinerary.user = user
itinerary.save!

itinerary_two = Itinerary.new(
  starting_point: "Plélo Colombier 35000 Rennes",
  end_point: "2 Av de Ker Lann 35170 Bruz",
  favorite: true
)

itinerary_two.user = user_two
itinerary_two.save!

itinerary_three = Itinerary.new(
  starting_point: "Place de la République, Rennes, Bretagne, France",
  end_point: "Bruz, Bretagne, France",
  favorite: true
)

itinerary_three.user = user_three
itinerary_three.save!

# Create itineraries_buses

print "Creating itinerary_buses"

it_bus = ItineraryBus.new(
  starting_point: "2 Square de la Fée Viviane 35000 Rennes",
  end_point: "Republique 35000 Rennes"
)
it_bus.itinerary = itinerary
it_bus.bus = bus_53
it_bus.save!

it_bus_two = ItineraryBus.new(
  starting_point: "Plélo Colombier 35000 Rennes",
  end_point: "2 Av de Ker Lann 35170 Bruz"
)
it_bus_two.itinerary = itinerary_two
it_bus_two.bus = bus_157
it_bus_two.save!

it_bus_two = ItineraryBus.new(
  starting_point: "18 Rue de Bertrand, 35000 Rennes",
  end_point: "1 Sq. du Chêne Germain, 35510 Cesson-Sévigné"
)
it_bus_two.itinerary = itinerary_three
it_bus_two.bus = Bus.find_by(star_bus_id: 1652948424)
it_bus_two.save!
