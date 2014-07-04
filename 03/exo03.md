# Initiation à la programmation... avec la NASA

Pour cette initiation à la programmation pas vraiment comme les autres, nous
allons nous baser sur un exemple concret, à base de NASA et d'exoplanètes&nbsp;!

Si vous n'avez pas suivi, commencez donc au [premier chapitre]().

## Python => Ruby

Pour ce tutoriel nous allons revenir à Ruby.

J'ai donc traduit notre précédent script: observez les différences, les points communs... nous allons bien sûr voir ça étape par étape.

**exo2c.rb**

```ruby
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
```  

Si vous exécutez ce script:

```
> ruby exo2c.rb 2000
```  

vous obtenez exactement le même résultat qu'en Python.

Ligne 1:

`#!/usr/bin/env ruby`

informe le système d'exploitation que le contenu de ce fichier est du Ruby exécutable. On n'a pas besoin d'approfondir ça pour le moment, mais ça servira plus tard.

Ligne 2: comme on avait fait en Python, on a rajouté ici une ligne qui _force_ Ruby à utiliser l'encodage de caractères UTF-8.

Lignes 3 et 4: on importe les modules pour traiter le JSON et pour se connecter au serveur.

Précision: il se peut que votre installation de Ruby ne contienne pas le module "rest client". Il faudra alors l'installer:

`> gem install rest-client`

Ce module nous servira à créer une méthode perso "download" qui aura la même fonction que le module importé "urllib" de Python.

Ensuite on crée notre classe et nos méthodes (pas de parenthèses à la fin si pas de paramètres). J'ai ajouté dans la méthode d'initialisation une variable d'instance contenant la base de l'URL de EXO, exactement comme en Python.

Dans "get_planets", ligne 2: on utilise donc notre propre méthode pour downloader à partir d'un serveur. 

Je ne précise pas ici le fonctionnement précis du module "rest client" pour ne pas alourdir ce chapitre avec des notions qui ne sont pas encore indispensables, on verra ça plus tard.

Résumé: la variable `content` contient la réponse de la méthode `download` à qui l'on avait passé en paramètre l'URL du serveur construite auparavant.

Cette réponse étant du JSON, on la décode grâce au module importé puis on retourne la réponse à l'objet qui a appellé.

La méthode "get_names" fonctionne comme en Python, mais la syntaxe est différente. Voyons en détail.

D'abord on crée un tableau vide, ça c'est pareil.

Ensuite la ligne:

```ruby
planet_list.each do |planet|
```  

signifie "dans la liste 'planet_list', prends chaque élément et traite-le comme étant l'objet 'planet', merci".

'.each' est une méthode très utilisée en Ruby, qui remplace la boucle "for" vue en Python.

On peut appliquer '.each' à tout objet énumérable: tableaux, dictionnaires, listes, etc.

Ensuite on a:

```ruby
names << planet['name']
```  

qui signifie "injecte dans le tableau 'names' la valeur de la clé 'name' du dictionnaire 'planet', 'planet' étant chaque objet dans la liste 'planet_list' dans laquelle nous sommes en train d'itérer".

Puis, comme en Python, on retourne le tableau 'names' à qui l'a appellé.

Notre méthode "print_list" est identique à la version Python mais utilise la méthode "each" _de_ l'objet tableau au lieu d'utiliser une boucle "for" _sur_ l'objet tableau.

Voilà! Nous avons traduit notre code Python en Ruby.

J'ai volontairement gardé la même organisation que dans le script précédent pour pouvoir étudier et comparer plus facilement.

Mais ce script n'est du coup plus très Rubyesque, nous allons donc maintenant nous attaquer à son _refactoring_.

## Cent fois sur le métier...

Ruby propose de nombreuses aides syntaxiques pour obtenir du code propre et compact.

Nous allons transformer nos formules un peu lourdes en quelque chose de plus Rubyesque: non seulement ça va nous permettre d'apprendre à 'refactor' notre code pour le rendre plus modulaire, mais nous allons en profiter pour approfondir et/ou eclaircir certains concepts déjà vus.

