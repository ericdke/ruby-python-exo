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
    decoded_planets = JSON.load(download(make_url_planets_year))
    decoded_planets['response']['results']
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

end

exo = NasaExo.new(ARGV[0])
exo.print_names
