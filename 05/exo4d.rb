#!/usr/bin/env ruby
# encoding: utf-8
require 'json'
require 'rest_client'

class ExoNetwork

  def initialize
    @api_base = 'http://exoapi.com/api/skyhook/'
  end

  def make_url_planets_year year
    @api_base + 'planets/search?disc_year=' + year
  end

  def download url
    RestClient.get(url) {|response, request, result| response}
  end

  def download_planets_by_year year
    JSON.load(download(make_url_planets_year(year)))['response']['results']
  end

end

class ExoDisplay

  def print_list my_list
    my_list.each {|obj| puts obj}
  end

  def print_details details
    puts "\n"
    details.compact!.each do |planet_details|
      planet_details.each {|key, value| puts "#{key.capitalize.ljust(16)} #{value.to_s.capitalize}"}
      puts "\n"
    end
  end

  def print_little_ones planets, max_mass
    littles = planets.map {|planet| planet if planet['mass'] < max_mass}
    print_details(littles)
    puts "#{littles.length} planets found in the database for this request\n"
  end

end

class ExoPlanets

  def initialize
    @network = ExoNetwork.new
    @display = ExoDisplay.new
  end

  def get_planets_by_year year
    @network.download_planets_by_year(year).map do |obj|
      {
        'name' => obj['name'],
        'class' => obj['mass_class'],
        'atmosphere' => obj['atmosphere_class'],
        'composition' => obj['composition_class'],
        'mass' => obj['mass'],
        'gravity' => obj['gravity'],
        'size' => obj['appar_size'],
        'star' => obj['star']['name'],
        'constellation' => obj['star']['constellation']
      }
    end
  end

  def print_names planet_list
    puts "\n- All planet names:\n\n"
    @display.print_list(planet_list.map {|planet| planet['name']})
  end

  def print_little_ones planets, max_mass
    puts "\n- Planets with a mass less than #{max_mass}:\n"
    @display.print_little_ones(planets, max_mass)
  end

end

exo = ExoPlanets.new
year = ARGV[0]
planets = exo.get_planets_by_year(year)
exo.print_names(planets)
exo.print_little_ones(planets, 200)
