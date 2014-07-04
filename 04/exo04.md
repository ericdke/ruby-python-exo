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

Par exemple, vous voulez afficher une planète de la liste *uniquement* si sa taille est supérieure à une valeur de votre choix.

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

Nous disions donc: vous voulez afficher une planète de la liste *uniquement* si sa taille est supérieure à une valeur de votre choix.

Une valeur de 1 représente la même masse que la Terre: une masse de 2 représente le double, etc.

Disons qu'on va chercher les planètes inférieures à une masse de 200.

Nous allons partir du résultat donné par notre méthode "get_details" et faire un tri (dans une nouvelle méthode):

**exo4c.py**

```python

```  

