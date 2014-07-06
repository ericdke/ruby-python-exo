#!/usr/bin/env ruby
# encoding: utf-8
require 'json'
require 'rest_client'

class ExoNetwork

  def initialize
    @api_base = 'http://exoapi.com/api/skyhook/'
  end

  def decode_json response
    JSON.load(response)['response']['results']
  end

  def download url
    decode_json(RestClient.get(url) {|response, request, result| response})
  end

  def download_planets_by_year year
    download("#{@api_base}planets/search?disc_year=#{year}")
  end

end

class ExoDisplay

  def print_list my_list
    my_list.each {|obj| puts obj}
  end

  def print_details liste
    puts "\n"
    liste.compact!.each do |planet_details|
      planet_details.each {|key, value| puts "#{key.capitalize.ljust(16)} #{value.to_s.capitalize}"}
      puts "\n"
    end
    puts "#{liste.length} planets found in the database for this request\n"
  end

  def print_little_ones planets, max_mass
    littles = planets.map {|planet| planet if planet['mass'] < max_mass}
    print_details(littles)
  end

end

class ExoPlanets

  def initialize
    @network = ExoNetwork.new
    @display = ExoDisplay.new
  end

  def make_planet obj
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

  def get_planets_by_year param
    begin
      year = Integer(param)
      result = @network.download_planets_by_year(year).map {|obj| make_planet(obj)}
      unless result.nil?
        return result
      else
        abort "\nOops ! Le serveur n'a retourné aucune information.\n\nVeuillez recommencer avec une année valide.\n\n"
      end
    rescue ArgumentError, TypeError
      abort "\nErreur ! Veuillez préciser une année (ex: 'ruby exo5a.rb 2000').\n\n"
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
