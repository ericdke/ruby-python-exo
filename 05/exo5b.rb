#!/usr/bin/env ruby
# encoding: utf-8
require 'json'
require 'rest_client'

class ExoNetwork
  def initialize
    @api_base = 'http://exoapi.com/api/skyhook/'
  end

  def download_planets_by_year year
    download "#{@api_base}planets/search?disc_year=#{year}"
  end

  def download url
    begin
      result = RestClient.get(url) {|response, request, result| response}
    rescue SocketError, SystemCallError
      ExoErrors.abort_cnx
    end
    JSON.load(result)['response']['results']
  end
end

class ExoDisplay
  def print_list my_list
    my_list.each {|obj| puts obj}
  end

  def print_excerpt liste
    liste.each do |obj|
      puts "#{obj['nom'].ljust(16)} Masse : #{obj['masse']}"
    end
    puts "\nTotal : " + liste.length.to_s
  end

  def print_details liste
    cleaned = liste.compact
    sorted = cleaned.sort_by {|obj| obj['masse']}
    sorted.each do |planet|
      planet.each do |key, value|
        puts "#{key.capitalize.ljust(16)} #{value.to_s.capitalize}"
      end
      puts "\n"
    end
    quantity = cleaned.length
    french =  case quantity
              when 0
                'Aucune planète ne correspond à cette requête.'
              when 1
                'Une seule planète trouvée pour cette requête.'
              else
                "#{quantity} planètes correspondent à cette requête."
              end
    puts "#{french}\n\n"
  end

  def print_little_ones planets, max_mass
    puts "\n- Filtre : masse inférieure à #{max_mass}\n\n"
    littles = planets.map {|planet| planet if planet['masse'] < max_mass}
    print_details littles
  end
end

class ExoPlanets
  def initialize
    @network = ExoNetwork.new
    @display = ExoDisplay.new
  end

  def make_planet obj
    {
      'nom' => obj['name'],
      'classe' => obj['mass_class'],
      'atmosphère' => obj['atmosphere_class'],
      'composition' => obj['composition_class'],
      'masse' => obj['mass'],
      'gravité' => obj['gravity'],
      'taille' => obj['appar_size'],
      'etoile' => obj['star']['name'],
      'constellation' => obj['star']['constellation']
    }
  end

  def get_planets_by_year param
    begin
      year = Integer param
      result = @network.download_planets_by_year(year).map {|obj| make_planet(obj)}
      if result.nil? || result.empty?
        ExoErrors.abort_no_info
      else
        return result
      end
    rescue ArgumentError, TypeError
      ExoErrors.abort_no_year
    end
  end

  def print_names planet_list
    puts "\n- Liste des noms de planètes :\n\n"
    @display.print_list(planet_list.map {|planet| planet['nom']})
  end

  def print_little_ones planets, max_mass
    @display.print_little_ones planets, max_mass
  end

  def print_excerpt planets, year
    puts "\n- Planètes découvertes en #{year} :\n\n"
    @display.print_excerpt planets
  end
end

class ExoErrors
  def self.abort_cnx
    abort "\nErreur de connection avec le serveur EXO.\n\n"
  end
  def self.abort_no_info
    abort "\nOops ! Le serveur n'a retourné aucune information. Veuillez recommencer avec une année valide.\n\n"
  end
  def self.abort_no_year
    abort "\nErreur ! Veuillez préciser une année (ex : 'ruby exo.rb 2000').\n\n"
  end
end

exo = ExoPlanets.new
année = ARGV[0]
planètes = exo.get_planets_by_year année
#exo.print_names planètes
exo.print_excerpt planètes, année
exo.print_little_ones planètes, 200
