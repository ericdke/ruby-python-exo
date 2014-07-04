#!/usr/bin/env ruby
# encoding: utf-8
require 'json'
require 'rest_client'

class NasaExo

  def initialize(year)
    @year = year
    @api_base = 'http://exoapi.com/api/skyhook/'
  end

  def get_planets
    JSON.load(download(make_url_planets_year))['response']['results']
  end

  def get_names(planet_list)
    planet_list.map {|planet| planet['name']}
  end

  def print_list(my_list)
    my_list.each {|obj| puts obj}
  end

  def make_url_planets_year
    @api_base + 'planets/search?disc_year=' + @year
  end

  def download(url)
    RestClient.get(url) {|response, request, result| response}
  end

  def print_names
    print_list(get_names(get_planets))
  end

  def make_details
    get_planets.map do |obj|
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

  def print_details
    puts "\n"
    make_details.each do |planet_details|
      planet_details.each {|key, value| puts "#{key.capitalize.ljust(16)} #{value.to_s.capitalize}"}
      puts "\n"
    end
  end

end

exo = NasaExo.new(ARGV[0])
exo.print_details
