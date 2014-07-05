# Initiation à la programmation... avec la NASA

Pour cette initiation à la programmation pas vraiment comme les autres, nous
allons nous baser sur un exemple concret, à base de NASA et d'exoplanètes&nbsp;!

Si vous n'avez pas suivi, commencez donc au [premier chapitre]().

## De retour à Python!

Voici notre précédent script Ruby traduit en Python.

Surtout des différences cosmétiques...

**exo3b.py**

```python
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

    def print_details(self):
        for planet_details in self.make_details():
            print "Name".ljust(16), ":", planet_details['name']
            del planet_details['name']
            for key,value in planet_details.iteritems():
                print key.capitalize().ljust(16), ":", str(value).capitalize()
            print ""

exo = NasaExo(sys.argv)
exo.print_details()
```  

Une nouveauté cependant, dans la méthode "get_names":

```python
return [planet['name'] for planet in planet_list]
```  

On appelle ça une "comprehension list" et c'est la même fonctionnalité que ".map" en Ruby.

Ici, on crée une liste contenant chaque élément `planet['name']` de chaque `planet` dans `planet_list`, puis on la retourne au demandeur.

Autre chose: la méthode "print_details" est sensiblement différente. Les raisons sont complexes et il est trop tôt pour les aborder, ça compliquerait trop ce tutoriel (indice: les dictionnaires ne sont pas ordonnés en Python).

## Nouveaux concepts

Je vous ai entraîné jusqu'à présent vers une manière de coder très *objet*, car j'aime ça.

Mais on peut aussi utiliser des outils qui viennent de la programmation procédurale: les conditions.

Par exemple, vous voulez afficher une planète de la liste *uniquement* si sa taille est inférieure à une valeur de votre choix.

Nous allons utiliser pour cela `if`.

Mais avant de l'utiliser dans notre app, un petit exemple tout simple:

**exo4a.py**

```python
import sys
mot = sys.argv[1]
longueur = len(mot)
if longueur < 5:
    print "Mot court:",
else:
    print "Mot long:",
print longueur, "lettres"
```  

```
> python exo4a.py bonjour
```  

Résultat: "Mot long: 7 lettres".

Simplissime: "si" condition remplie alors option 1, "sinon" option 2.

Un autre exemple:

**exo4b.py**

```python
# _*_ encoding: utf-8 _*_
import sys
mot = sys.argv[1].lower()
if mot == "merci":
    print "Bravo! C'était le mot magique."
elif mot == "wtf":
    print "En effet, ce 'elif' est un peu WTF. Je préfèrerais 'elsif' ou 'else if'..."
else:
    print "Vous avez tapé", mot.upper(), "et puis c'est tout."
```  

```
> python exo4b.py bonjour
> python exo4b.py wtf
> python exo4b.py merci
```  

Vous avez remarqué le "double égal", `==` ?

En Python comme en Ruby et comme dans la plupart des langages, on *attribue* avec `=` et on *compare* avec `==`.

Ben voilà, vous en savez à peu près assez pour passer à la suite du développement de notre app. :)

## Go!

Nous disions donc: vous voulez afficher une planète de la liste *uniquement* si sa taille est inférieure à une valeur de votre choix.

En astronomie, une masse de 1 représente la même masse que la Terre: une masse de 2 représente le double, etc.

Disons qu'on va chercher les planètes inférieures à une masse de 200 (il n'y en a pas beaucoup).

Nous allons partir du résultat donné par notre méthode "make_details" et faire un tri (dans une nouvelle méthode "print_little_ones"):

**exo4c.py**

```python
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
exo.print_little_ones(planets, 200)
```  

Donc ici que se passe-t-il ?

On récupère la liste des planètes avec 

```python
planets = exo.make_details()
```  

puis on appelle notre nouvelle méthode "print_little_ones" avec deux arguments&nbsp;: cette liste de planètes, et la valeur pour notre filtre.

La méthode récupère la liste et la valeur et les stocke dans deux variables, "planets" et "max_mass":

```python
def print_little_ones(self, planets, max_mass):
```  

Ensuite nous créons une liste vide.

Puis nous itérons sur la liste "planets", en déclarant chacun des objets de cette liste comme étant nommé "planet".

Vient notre condition:

```python
if planet['mass'] < max_mass:
```  

On récupère la valeur donnée par le serveur pour la masse de la planète avec `planet['mass']` puis on demande si cette valeur est inférieure (`<`) à la valeur que l'on a fourni à la méthode (`max_mass`).

Si le résultat se vérifie (on dit: si le résultat est "True"), alors l'instruction imbriquée pour ajouter cette planète à notre nouvelle liste sera exécutée: sinon, Python passe à la suite (la prochaine planète).

On appelle alors notre méthode pré-existante "print_details" en lui passant notre nouvelle liste, et on conclut pour le plaisir avec un décompte du nombre de planètes correspondant à notre requête.

Ce qui serait bien, c'est de pouvoir donner à la ligne de commande des options pour décider si on veut récupérer toutes les planètes, ou alors avec des conditions, n'en récupérer qu'un certain nombre, etc.

Nous étudierons tout cela dans le dernier chapitre; en attendant, nous allons ajouter encore quelques éléments et modifier la structure.

## Classes

Notre script commence à prendre de l'ampleur, et je trouve que notre classe NasaExo est désordonnée.

Elle contient du code qui ne concerne que l'affichage de listes: ce code n'a rien à faire dans une classse dédiée à la Nasa. Pareil avec les parties concernant le réseau.

Nous allons déplacer ces méthodes dans des classes "ExoDisplay" et "ExoNetwork" et rationaliser notre script dans un souci de modularité:

**exo4d.py**

```python
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
```  

