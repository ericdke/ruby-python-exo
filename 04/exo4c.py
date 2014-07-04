# _*_ encoding: utf-8 _*_
import sys
import json
import urllib

class NasaExo():

    def __init__(self, params):
        self.year = params[1]
        self.api_base = 'http://exoapi.com/api/skyhook/'

    def get_planets(self):
        return json.loads(self.download(self.make_url_planets_year()))['response']['results']

    def download(self, url):
        return urllib.urlopen(url).read()

    def get_names(self, planet_list):
        return [planet['name'] for planet in planet_list]

    def print_list(self, my_list):
        for obj in my_list:
            print obj

    def make_url_planets_year(self):
        return self.api_base + 'planets/search?disc_year=' + self.year

    def print_names(self):
        return self.print_list(self.get_names(self.get_planets()))

    def make_details(self):
        result = []
        for obj in self.get_planets():
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
        print len(littles), "planets have a mass <", max_mass


exo = NasaExo(sys.argv)
planets = exo.make_details()
# exo.print_details(planets)
exo.print_little_ones(planets, 200)
