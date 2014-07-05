# _*_ encoding: utf-8 _*_
import sys
import json
import urllib

class ExoNetwork():

    def __init__(self):
        self.api_base = 'http://exoapi.com/api/skyhook/'

    def make_url_by_year(self, year):
        return self.api_base + 'planets/search?disc_year=' + year

    def download(self, url):
        return urllib.urlopen(url).read()

    def decode_json(self, response):
        return json.loads(response)

    def download_and_decode(self, url):
        return self.decode_json(self.download(url))['response']['results']

    def download_planets_by_year(self, year):
        return self.download_and_decode(self.make_url_by_year(year))

class ExoDisplay():

    def print_list(self, my_list):
        for obj in my_list:
            print obj

    def print_details(self, details):
        for planet_details in details:
            print "Name".ljust(16), ":", planet_details['name']
            del planet_details['name']
            for key,value in planet_details.iteritems():
                print key.capitalize().ljust(16), ":", str(value).capitalize()
            print ""

    def print_little_ones(self, planets, max_mass):
        littles = []
        for planet in planets:
            if planet['mass'] < max_mass:
                littles.append(planet)
        self.print_details(littles)
        print len(littles), "planets found in the database for this request"

class ExoPlanets():

    def __init__(self):
        self.network = ExoNetwork()
        self.display = ExoDisplay()

    def get_planets_by_year(self, year):
        result = []
        for obj in self.network.download_planets_by_year(year):
            x = {
                'name': obj['name'],
                'class': obj['mass_class'],
                'atmosphere': obj['atmosphere_class'],
                'composition': obj['composition_class'],
                'mass': obj['mass'],
                'gravity': obj['gravity'],
                'size': obj['appar_size'],
                'star': obj['star']['name'],
                'constellation': obj['star']['constellation']
            }
            result.append(x)
        return result

    def print_names(self, planet_list):
        print "\n- All planet names:\n"
        self.display.print_list([planet['name'] for planet in planet_list])

    def print_little_ones(self, planets, max_mass):
        print "\n- Planets with a mass less than", str(max_mass) + ":\n"
        self.display.print_little_ones(planets, max_mass)

exo = ExoPlanets()
year = sys.argv[1]
planets = exo.get_planets_by_year(year)
exo.print_names(planets)
exo.print_little_ones(planets, 200)
