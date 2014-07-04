#!/usr/bin/env ruby
# encoding: utf-8
require 'json'
require 'rest_client'

class NasaExo

  def initialize(params)
    @year = params[0]
    @api_base = 'http://exoapi.com/api/skyhook/'
  end

  def what_year
    puts "L'année demandée est: " + @year
  end

  def get_planets
    url = @api_base + 'planets/search?disc_year=' + @year
    content = download(url)
    decoded_planets = JSON.load(content)
    return decoded_planets['response']['results']
  end

  def get_names(planet_list)
    names = []
    planet_list.each do |planet|
      names << planet['name']
    end
    return names
  end

  def print_list(my_list)
    my_list.each do |obj|
      puts obj
    end
  end

  def download(url)
    RestClient.get(url) do |response, request, result|
      return response
    end
  end

end


exo = NasaExo.new(ARGV)

planet_list = exo.get_planets

names = exo.get_names(planet_list)

exo.print_list(names)
