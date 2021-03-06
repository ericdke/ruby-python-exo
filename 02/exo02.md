# Initiation à la programmation... avec la NASA

Pour cette initiation à la programmation pas vraiment comme les autres, nous
allons nous baser sur un exemple concret, à base de NASA et d'exoplanètes&nbsp;!

Si vous n'avez pas suivi, commencez donc au [premier chapitre]().

## De Ruby à Python

Pour ce tutoriel nous allons poursuivre en Python. 

Et pour simplifier le suivi, j'ai déjà adapté le code Ruby du précédent chapitre en code Python. 

Nous allons découvrir ensemble quelques points communs et différences entre ces deux langages, en tout cas au niveau qui nous concerne pour ce tuto.

Pas de panique : je vous tiens par la main, tout va bien se passer.&nbsp;:)

La plus grande différence entre ces deux langages&nbsp;:

**L'indentation du code en Python est _obligatoire_ et significative.**

**exo2.py**

```python
# _*_ encoding: utf-8 _*_

import sys

class NasaExo():

    def __init__(self, params):
        self.year = params[1]

    def what_year(self):
        print "L'année demandée est", self.year

exo = NasaExo(sys.argv)
exo.what_year()
```  

On voit bien que c'est la même application que ce que nous avons fait en Ruby, même si quelques détails changent. 

La plus grande différence&nbsp;: il n'y a plus de `end` mais, à la place, une indentation du code.

C'est cette indentation qui indique à Python la hiérarchie du code&nbsp;: Python sait que la méthode `what_year` est dans la classe `NasaExo` car `what_year` est décalé d'un tab (quatre espaces pour Python par convention) par rapport à la classe.

![Indentation significative](https://files.app.net/2x3gc3IiX.png)


*Mais reprenons ligne par ligne.*

```python
# _*_ encoding: utf-8 _*_
```  



J'ai ajouté au début une instruction spéciale, qui ressemble à un commentaire car placée après un `#`, mais qui est un moyen de forcer Python à utiliser l'encodage de caractères en UTF-8, c'est-à-dire avec les accents du Français, les kanji japonais, les emoticons, etc.

Je ne l'avais pas fait dans l'exercice précédent car Ruby est plus tolérant mais c'est le même principe. 

Si vous n'êtes pas certain de comprendre ce qui se passe sur cette ligne, essayez juste de faire tourner ce script sans elle, vous verrez que Python n'est pas content du tout si votre texte contient des accents...

Ensuite&nbsp;:

`import sys`

`import` existe aussi en Ruby (`require`) mais on n'en n'avait pas eu besoin.

Ca signifie qu'on importe dans notre app des méthodes qui sont définies ailleurs (ici, dans la "bibliothèque standard" de Python) et qui ne sont donc pas chargées par défaut.

Là, on demande "Python, dans mon app je veux pouvoir utiliser les fonctions de ton module `sys`, merci".

`sys`&nbsp;: des fonctions pour utiliser le système d'exploitation. Ici, necessaire pour avoir accès à la constante ARGV (alors que Ruby nous le donne directement).

Ensuite, définition de la classe&nbsp;:

```python
class NasaExo():
```  

Dans Ruby la plupart des parenthèses ne sont pas obligatoires, et donc je ne les avais pas mentionnées si pas necessaires.

En revanche dans Python il faut les écrire, même si il n'y a pas de paramètres (on met alors des parenthèses vides).

Et *toujours* terminer une définition par `:` (deux points).

En revanche, pas besoin de `end`: c'est l'indentation qui indique la hiérarchie. 

Tout ce qui suivra cette déclaration de classe *et qui sera indenté* appartiendra à la classe. Pour sortir de la classe, il suffit de réduire l'indentation.

Ensuite, la méthode d'initialisation de la classe. 

C'est le même principe qu'en Ruby mais formulé un peu différemment&nbsp;:

```python
    def __init__(self, params):
        self.year = params[1]
```  

On a `__init__` au lieu de `initialize`, mais c'est pareil.

Mais on a aussi un `self` avant la variable de paramètres, c'est quoi&nbsp;? 

Hé bien ici l'explication complète est complexe et pas necessaire pour le moment, on va donc juste accepter le fait.&nbsp;:)

Disons simplement que ce `self` c'est le même que celui de la ligne suivante, `self.year` et que ça donne l'équivalent de la variable d'instance en Ruby `@year`.

*Le `self`, tout comme `@`, représente ici l'appartenance à la classe.*

Ensuite, on remarque que l'on pioche le deuxième élément du tableau ARGV au lieu du premier comme en Ruby.

*Souvenez-vous, les tableaux sont indexés à partir de 0, donc le deuxième élément est d'index 1.*

C'est parce qu'en Python, le premier élément de ARGV est le nom du fichier de l'application en cours d'exécution.

Méthode suivante&nbsp;:

```python
    def what_year(self):
        print "L'année demandée est", self.year
```  

Encore ce `self` ! Hé oui, ben si vous voulez faire du Python va juste falloir s'y habituer...&nbsp;:)

En Python, une méthode prend *toujours* au moins `self`.

Elle prend `self` *puis* son paramètre (comme on l'a vu pour `__init__`); sinon elle prend seulement `self` (la référence à sa classe).

Ensuite on affiche un texte suivi de la variable d'instance qui contient l'année demandée par l'utilisateur dans ARGV (voir 1er chapitre).

On aurait aussi pu, comme en Ruby, faire

```python
print "L'année demandée est " + self.year
```  

mais la formule "texte puis virgule puis variable" est typiquement pythonesque.

Nous voici maintenant revenus en dehors de la classe (indentation nulle) pour instancier celle-ci&nbsp;:

```python
exo = NasaExo(sys.argv)
```  

Dans Ruby on a directement un constante ARGV, mais en Python il faut appeler la méthode `argv` sur l'objet `sys` que l'on a précédemment importé.

Et pour finir on appelle la méthode `what_year` sur l'objet `exo`, comme en Ruby (on ajoute juste les parenthèses vides après le nom de la méthode alors que c'est optionnel en Ruby)&nbsp;:

```python
exo.what_year()
```  

Youpi&nbsp;! On vient de traduire du Ruby en Python&nbsp;! 

Et le bonus&nbsp;: le plus dur est fait. Vous venez déjà de voir les détails les plus énervants pour ce qui concerne la différence entre les deux.

Bien sûr il y a *énormément* d'autres différences, mais elles ne sont pas énervantes.&nbsp;:)

## La NASA ! La NASA !

Ouiiii&nbsp;! Nous y voilà...

Notez l'url de l'API qui nous concerne&nbsp;:

`http://exoapi.com/api/skyhook/`

On va l'intégrer dans notre classe sous la forme d'une variable d'instance, dans la méthode d'initialisation&nbsp;:

```python
    def __init__(self, params):
        self.year = params[1]
        self.api_base = 'http://exoapi.com/api/skyhook/'
```  

Cette variable `self.api_base`, tout comme en Ruby on aurait pu avoir `@api_base`, sera accessible par toutes les méthodes de la classe instanciée.

Comme on va parler à un serveur en JSON, nous avons aussi besoin des modules optionnels pour traiter ce format. On va utiliser `import json` (en Ruby on aurait fait `require 'json'`).

Il nous faut également de quoi nous *connecter* au serveur en HTTP, lui envoyer des requêtes et recevoir ses réponses&nbsp;: `import urllib`. 

Ensuite on va s'ajouter une petite méthode qui va construire l'url en lui ajoutant l'année demandée, au bon format demandé par le serveur.

Voici notre script mis à jour&nbsp;:

**exo2.py**

```python
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
        return url

exo = NasaExo(sys.argv)
exo.what_year()
print exo.get_planets()
```  

Première nouveauté, le `return`&nbsp;: c'est simple, ça *renvoie* la résultat de la méthode à l'objet qui a appellé la méthode.

Ici, la méthode `get_planets` *renvoie* la valeur à `exo.get_planets()` et on l'affiche avec `print`.

Jusque là, tout va bien&nbsp;? Hé, on apprend deux langages en même temps et on va se connecter à la NASA, la classe&nbsp;!&nbsp;:)

Testez donc ce script comme ceci&nbsp;:

```
> python exo2.py 2012
```  

Le résultat doit donner&nbsp;:

```
L'année demandée est 2012
http://exoapi.com/api/skyhook/planets/search?disc_year=2012
```  

## Mais allez, la NASA, quoi!

Voilà, oh&nbsp;! Impatient, va.&nbsp;;)

**exo2b.py**

```python
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

exo = NasaExo(sys.argv)
exo.what_year()
planet_list = exo.get_planets()
print planet_list[0]
```  

Ah oui, alors tout de suite ça calme...

Non je plaisante, en fait c'est super simple&nbsp;!&nbsp;:)

Première ligne de notre méthode "get_planets"&nbsp;:

```python
url = self.api_base + 'planets/search?disc_year=' + self.year
```  

Ici, on prend la variable qui contient l'url de base, on ajoute la suite de l'url (correspondant à notre requête) et on ajoute enfin l'année demandée.

Deuxième ligne&nbsp;:

```python
cnx = urllib.urlopen(url)
```  

On crée une variable "cnx" (j'aurais pu la nommer "pizza" mais... bon, vous avez déjà lu le premier chapitre, alors vous savez) et dans cet objet on stocke l'appel au serveur, *la connexion*.

Oui, on crée un objet abstrait qui contient la connexion vers le serveur, c'est comme ça que ça marche.

On appelle, sur l'objet importé `urllib`, la méthode `urlopen` avec en paramètre l'url qu'on vient de construire&nbsp;: ça crée une connexion, que l'on stocke dans la variable nommée `cnx`.

Troisième ligne&nbsp;:

```python
content = cnx.read()
```  

On stocke dans une variable nommée `content` (comme 'contenu' en anglais) le résultat de l'appel de la méthode `read` sur l'objet `cnx` (la connexion) que l'on vient de construire.

Ca active la connexion, lit le contenu donné par le serveur, et le stocke dans la variable.

Facile. :)

Ensuite&nbsp;:

```python
decoded_planets = json.loads(content)
```  

On crée une variable `decoded_planets` et on y stocke non pas notre contenu mais ce contenu *décodé* par la fonction `json` que l'on a précédemment importée.

Car le contenu JSON brut délivré par le serveur n'est pas utilisable tel quel, il faut le décoder vers des structures que connaît Python, comme des tableaux ou dictionnaires&nbsp;: c'est ce que fait ce module.

Notre variable `decoded_planets` contient maintenant un gros dictionnaire plein d'objets complexes représentant des planètes&nbsp;: nous en retournons le contenu du champ `['response']['results']` avec 

```python
return decoded_planets['response']['results']
```  

ce contenu est un *tableau*, qui retourne dans `planet_list`, et dont nous affichons le *premier objet*&nbsp;:

```python
print planet_list[0]
```  

Maintenant que vous avez lu cette explication étape par étape, relisez le script `exo2b.py`, vous devriez l'interpréter sans grande difficulté.

Et surtout, lancez-le !

```
> python exo2b.py 2000
```  

Et observez la beauté de cette exoplanète... euh, bon, c'est un peu le dawa, on s'y perd dans ce JSON, il va falloir trier.

Et c'est l'objet de notre leçon, avec en bonus du 'refactoring'. Woohoo&nbsp;!

## Tri et stockage

On voit que l'objet renvoyé par le serveur est complexe&nbsp;; et encore, ce n'est que le premier de la liste, qui en contient plein&nbsp;!

Nous allons donc trier *des objets à partir de la liste*, et ensuite *des infos à partir de chaque objet*.

Quand je dis 'trier', je pense à 'extraire', 'ranger' et 'stocker'.

Nous allons aussi, mais de manière diluée et au fur et à mesure, reformuler (éclater, rationaliser) les méthodes de notre classe pour en faire des objets plus matures.

Au lieu de juste afficher le premier objet de la liste qui contient toutes les infos sur une planète, on va découvrir comment itérer (faire un boucle) sur cette liste et obtenir, par exemple, uniquement le *nom* de chaque planète.

Pour cela on va créer dans la classe une méthode "get_names" et modifier un tout petit peu notre organisation&nbsp;:

**exo2c.py**

```python
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
noms = exo.get_names(planet_list)
exo.print_list(noms)
```  

**Et voilà, la liste des noms d'exoplanètes découvertes en l'an xxx&nbsp;!**

Allons-y étape par étape.

Tout d'abord à la fin du script, là où s'exécutent les actions, à l'avant-dernière ligne&nbsp;: 

Nous stockons dans `noms` le résultat de la méthode `get_names` à laquelle on a fourni la liste des planètes&nbsp;; ce résultat est une liste de noms, comme nous allons l'étudier.

Ensuite on appelle la méthode `print_list` en lui passant cette liste.

Voyons maintenant notre méthode `get_names`.

On commence par créer une liste (un tableau) vide pour y stocker les infos qui vont arriver&nbsp;:

`names = []` 

Ensuite on découvre la boucle `for`. Vaste sujet mais pour faire simple: on va boucler (itérer, c'est-à-dire opérer un à un sur l'ensemble) sur la liste.

A chaque itération (à chaque tour de la boucle) une nouvel objet de la liste est considéré.

A chaque fois, l'instruction est exécutée sur cet objet.

En détail&nbsp;:

```python
for planet in planet_list:
```  

signifie "pour chaque objet de la liste `planet_list` tu considères cet objet comme étant nommé `planet` puis..."

```python
names.append(planet['name'])
```  

On appelle la méthode `append` sur notre tableau `names`: cette méthode va ajouter quelque chose à ce tableau.

Cette chose est `planet['name']`, c'est-à-dire la valeur correspondant au champ `name` dans le dictionnaire `planet` (qui est lui-même un objet de la liste à chaque tour de boucle).

Finalement, avec

```python
return names
```  

on renvoie notre tableau plein de noms à qui l'a appelé&nbsp;: l'avant-dernière ligne (`noms = exo.get_names(planet_list)`).

Ce tableau de noms est renvoyé à la méthode `print_list` qui itère dans la liste et en affiche chaque objet&nbsp;:

```python
def print_list(self, my_list):
    for obj in my_list:
        print obj
```  

"Hey Python, pour chaque objet dans `my_list`, tu considères cet objet comme étant nommé `obj` puis tu l'afffiches".


## Conclusion

Ce second chapitre est plus court que le premier car plus concentré, il y a de nombreux nouveaux éléments à retenir.

Notre application existe désormais, et c'est formidable&nbsp;! Mais elle est très basique&nbsp;: nous allons très vite l'améliorer dans le prochain chapitre.

J'espère que cet article vous aura permis de vous initier à Python et à quelques concepts essentiels de la programmation.

La prochaine fois on reviendra à Ruby pour encore plus d'action&nbsp;!&nbsp;:)
