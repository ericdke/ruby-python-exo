# _*_ encoding: utf-8 _*_
import sys
import json
import urllib

class NasaExo():

    def __init__(self, params):
        self.year = params[1]
        self.api_base = 'http://exoapi.com/api/skyhook/'

    def what_year(self):
        print "L'année demandée est", self.year

    def get_planets(self):
        url = self.api_base + 'planets/search?disc_year=' + self.year
        cnx = urllib.urlopen(url)
        content = cnx.read()
        decoded_planets = json.loads(content)
        return decoded_planets['response']['results']

    def get_names(self, planet_list):
        names = []
        for planet in planet_list:
            names.append(planet['name'])
        return names

    def print_list(self, my_list):
        for obj in my_list:
            print obj

exo = NasaExo(sys.argv)
planet_list = exo.get_planets()
names = exo.get_names(planet_list)
exo.print_list(names)
