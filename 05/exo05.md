# Initiation à la programmation... avec la NASA

Pour cette initiation à la programmation pas vraiment comme les autres, nous
allons nous baser sur un exemple concret, à base de NASA et d'exoplanètes&nbsp;!

Si vous n'avez pas suivi, commencez donc au [premier chapitre]().

## Finissons sur du Ruby

Voici notre précédent script Python refait en Ruby, avec quelques améliorations au passage.

On note que les `return` sont omis (en Ruby on ne les indique que si explicitement necessaires).

Egalement disparues : les parenthèses optionnelles, sauf dans les rares cas où je préfère les laisser pour des raisons de lisibilité (notamment lors de l'appel des méthodes, mais c'est un choix personnel).

De plus, on découvre les conditions 'à droite' de Ruby, avec le `if` placé après l'objet considéré.

**exo4d.rb**

```ruby
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

  def get_planets_by_year year
    @network.download_planets_by_year(year).map {|obj| make_planet(obj)}
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
```  

Observons ceci dans notre méthode "print_little_ones"&nbsp;:

```ruby
littles = planets.map {|planet| planet if planet['mass'] < max_mass}
```  

C'est un "syntactic sugar" de Ruby qui permet de placer la condition *après* la variable à évaluer. 

Ce code est strictement équivalent à&nbsp;:

```ruby
littles = planets.map do |planet|
  if planet['mass'] < max_mass
    return planet
  end
end
```  

## Gestion d'erreurs

Nous n'en n'avons pas encore parlé ici par souci de simplicité, mais une des plus grandes difficultés pour le développeur c'est la gestion des erreurs.

La gestion des erreurs de l'application d'une part; et la gestion des erreurs de l'utilisateur d'autre part.

Erreurs de l'app : toutes les méthodes sont-elles propres et vont-elles s'exécuter correctement dans tous les contextes&nbsp;?

Erreurs de l'utilisateur&nbsp;: que se passe-t-il si, au lieu de faire&nbsp;:

```
> ruby exo4d.rb 2000
```  

on fait&nbsp;:

```
> ruby exo4d.rb hello
```  

On obtient deux choses&nbsp;: une liste de planètes qui ne contient aucune planète, car le serveur EXO n'a pas compris notre requête et renvoie un tableau vide. Bon, c'est pas bien grave. 

Mais ensuite, notre script plante&nbsp;! Car Ruby cherche à boucler dans la liste des planètes pour extraire les détails mais trouve `nil` à la place des éléments de la première planète (évidemment puisqu'il n'y a pas de planètes du tout).

On voit donc qu'il faut gérer tout ça. Heureusement, Python et Ruby offrent de nombreux mécanismes pour nous aider. 

Voici un tout petit aperçu de quelques méthodes.

### Sanitiser les entrées

Affreux anglicisme qui signifie simplement que l'on va vérifier ce que l'utilisateur donne à l'app et agir si quelque chose ne va pas. Exemple&nbsp;:

```ruby
def get_planets_by_year param
  begin
    year = Integer(param)
    @network.download_planets_by_year(year).map {|obj| make_planet(obj)}
  rescue ArgumentError
    abort "\nErreur ! Veuillez préciser une année (ex: 'ruby exo5a.rb 2000').\n\n"
  end
end
```  

Nous découvrons le mécanisme `begin/rescue` qui permet d'encapsuler une ou des instructions dans un bloc `begin` et l'exécuter si tout se passe bien, mais qui va lancer le bloc `rescue` si les instructions du bloc "begin" provoquent une erreur.

Ici nous avons la nouvelle instruction `Integer(param)` qui vérifie que `param` soit un nombre, et provoque une erreur `ArgumentError` si ce n'est pas le cas.

C'est donc pour nous un moyen de vérifier que l'utilisateur entre bien une année pour notre script&nbsp;: s'il entre un mot à la place, `Integer(param)` provoque une erreur `ArgumentError` qui est interceptée par le bloc `rescue` qui va alors exécuter son propre contenu au lieu de laisser l'application planter.

Dans ce bloc `rescue` nous pouvons mettre ce que nous voulons&nbsp;: ici, une instruction `abort` qui stoppe le script et affiche un message, évitant d'aller jusqu'au plantage.

Bon, mais si maintenant l'utilisateur ne rentre rien&nbsp;?

```
> ruby exo5a.rb

exo5a.rb:71:in `Integer': can't convert nil into Integer (TypeError)
  from 05/exo5a.rb:71:in `get_planets_by_year'
  from 05/exo5a.rb:92:in `<main>'
```  

Oops ! Plantage. Ruby nous dit qu'il ne sait pas convertir `nil` en nombre&nbsp;: on lui a donné une année qui est "rien" et il ne connaît pas ce nombre, évidemment...

Mais Ruby est sympa et nous donne le nom de l'erreur&nbsp;: `TypeError`. 

Nous allons donc ajouter une condition supplémentaire à notre `rescue`&nbsp;:

```ruby
def get_planets_by_year param
  begin
    year = Integer(param)
    @network.download_planets_by_year(year).map {|obj| make_planet(obj)}
  rescue ArgumentError, TypeError
    abort "\nErreur ! Veuillez préciser une année (ex: 'ruby exo5a.rb 2000').\n\n"
  end
end
```  

Nous aurions pu aussi simplement laisser `rescue` sans préciser aucun type d'erreur, mais c'est brutal&nbsp;:

```ruby
def get_planets_by_year year
  begin
    @network.download_planets_by_year(year).map {|obj| make_planet(obj)}
  rescue => err
    abort "\nErreur inconnue ! Voici l'horreur en question: \n\n#{err}\n\n"
  end
end
``` 

Je déconseille évidemment cette approche. :)

Une autre solution est de placer des valeurs par défaut pour éviter les plantages de ce type. Exemple&nbsp;:

```ruby
def get_planets_by_year year
  year = 2000 if year.nil?
  @network.download_planets_by_year(year).map {|obj| make_planet(obj)}
end
``` 

Mais dans ce cas il ne faut pas oublier de prévenir l'utilisateur de ce comportement.

Au passage, nous avons vu la méthode `.nil?` qui permet d'exprimer la même chose que:

```ruby
  year = 2000 if year == nil
```  

mais de manière plus "Rubyesque" à mon goût.

Bon, mais tout ça ne suffit pas&nbsp;! Regardez ceci par exemple&nbsp;:

```
> ruby exo5a.rb 1973

exo5a.rb:34:in `print_details': undefined method `each' for nil:NilClass (NoMethodError)
  from 05/exo5a.rb:43:in `print_little_ones'
  from 05/exo5a.rb:85:in `print_little_ones'
  from 05/exo5a.rb:94:in `<main>'
```  

Argh ! Aucune planète découverte en 1973, et donc plantage de la boucle.

Hmm, peut-être qu'il faut vérifier que l'année entrée soit correcte &nbsp; Mais comment le savoir&nbsp;? 

Non, ce n'est pas la bonne approche...

Ce qu'il faut faire, c'est éviter que le script plante si une liste de planète est vide, tout simplement.

Nous allons donc ajouter une instruction qui vérifie l'état de la liste et stoppe le script si elle est vide *avant* de déclencher la suite des évènements&nbsp;:

```ruby
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
```  

On découvre l'instruction `unless`&nbsp;: c'est comme `if` mais à l'envers.

Ici, la ligne 

```ruby
unless result.nil?
```  

signifie "à moins que `result` ne soit `nil`, alors fais ceci, sinon fais la branche `else`".

Bon, ça marche, on a intercepté la majorité des risques d'erreur pour cette partie de l'app.

Mais notre méthode `get_planets_by_year` commence à être un peu trop épaisse et mélange plusieurs contextes.

Quand nous allons ajouter de la gestion d'erreurs ailleurs dans notre app, ça va être un beau bordel avec tous ces messages à afficher&nbsp;!

Nous allons donc créer une classe "ExoErrors" qui va gérer tout ça.

## Ca prend forme !

Au passage, j'ai ajouté quelques gestions d'erreurs et nouvelles fonctions.

J'ai également modifié certaines méthodes uniquement pour vous montrer différentes manières de faire.

**exo5b.rb**

```ruby
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
      cnx = RestClient.get(url) {|response, request, result| [response, request, result]}
    rescue SocketError, SystemCallError
      ExoErrors.abort_cnx
    end
    JSON.load(cnx[0])['response']['results']
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
    puts "\nErreur ! Veuillez préciser une année (ex : 'ruby exo.rb 2000').\n\n"
    exit
  end
end

exo = ExoPlanets.new
année = ARGV[0]
planètes = exo.get_planets_by_year année
#exo.print_names planètes
exo.print_excerpt planètes, année
exo.print_little_ones planètes, 200
```  

Voyons les changements intéressants.

Dans la méthode `download` nous récupérons les trois variables retournées par RestClient dans un seul tableau (grâce aux `[]`). Utile si on veut ensuite débugger les connexions avec `request` et/ou `result`.

Puis on décode `response` qui se trouve au début du tableau (donc `cnx[0]`).

Comme avant, une fois ceci résolu, on en extrait la partie `['response']['results']` et comme c'est la dernière expression évaluée, c'est ce qui est retourné à l'appelant.

Attention à ne pas confondre les variables dont le nom est similaire mais qui ne correspondent pas du tout aux même éléments&nbsp;! 

Si vous êtes perdus, imaginez que vous auriez pu nommer les variables de RestClient comme `|pigeon, merle, corbeau| [pigeon, merle, corbeau]`&nbsp;: ça n'aurait pas changé le fait qu'il faille extraire `['response']['results']` de ce qui aura été décodé par `JSON.load` ensuite.&nbsp;:)

On voit aussi dans cette méthode "download" que j'ai ajouté une interception pour deux types d'erreur de connexion classiques.

En cas d'erreur, on appelle une méthode dans la classe "ExoErrors".

On remarque que cette classe n'a pas été instanciée et n'en a pas besoin&nbsp;: ses méthodes sont des *méthodes de classe* au lieu d'être des *méthodes d'instance*.

Voir la classe elle-même pour la différence de syntaxe. Attention, ce n'est pas tout à fait le même "self" qu'en Python...

Dans "ExoDisplay", on a ajouté une petite méthode `print_excerpt` pour présenter les noms de planètes avec un petit extrait d'informations.

C'est ensuite dans `print_details` que l'on trouve le plus de changements.

J'ai éclaté les instructions pour les rendre plus lisibles, mais d'habitude j'aurais écrit ça de manière plus compacte. Ca n'a en tout cas aucune incidence sur la vitesse d'exécution du script.

La ligne

```ruby
sorted = cleaned.sort_by {|obj| obj['masse']}
```  

se lit comme de l'anglais&nbsp;: 

dans le tableau `cleaned` (qui contient la liste des planètes sans aucun objet vide), itère sur le contenu et pour chaque objet considère le champ `masse`&nbsp;: trie la liste à partir de ce champ et renvoie le résultat dans `sorted`.

```ruby
quantity = cleaned.length
```  

nous donne la longueur du tableau, c'est-à-dire le nombre d'objets planètes.

On attribue ensuite dans la variable `french` le résultat de l'instruction `case/when/else` qui est assez facile à lire et donc à comprendre.

C'est une variante très pratique du `if/then/else`.

Ca nous permet de nous amuser à moduler une phrase en fonction d'une valeur ou de n'importe quel autre objet évaluable par `case` (ici, `quantity`).

Dans `get_planets_by_year` on découvre `||`&nbsp;:

```ruby
if result.nil? || result.empty?
```  

ça signifie `or` ("ou") et permet d'évaluer deux conditions. 

Dans notre cas on exécute `ExoErrors.abort_no_info` si `result` est `nil` ou si `result` est vide (donc pas inexistant mais tout de même plantogène).

Dans le même registre on trouve `&&` qui signifie `and` ("et") et dont vous pouvez imaginer la fonction aisément.

Et puis c'est à peu près tout&nbsp;! Le reste a déjà été vu sous une forme ou sous une autre. 

## Voilà !

A partir de ces informations basiques, vous pouvez extrapoler et déjà construire des scripts intéressants.

Bien entendu il y a encore quelques milliards d'autres choses à apprendre&nbsp;: à propos de la programmation elle-même, des langages et de leur syntaxes, des bibliothèques standard, des modules à importer, etc.

Et même les sujets que nous avons abordé&nbsp;: ils n'ont été qu'effleurés, et méritent d'être étudiés bien plus en profondeur.

Mais le but de ce tutoriel était d'apprendre rapidement l'essentiel des concepts tout en se concentrant sur une tâche concrète, la création d'une application *réelle* et amusante.

Selon votre niveau, vous avez pu vous perdre ou vous ennuyer; j'espère cependant avoir visé assez juste pour vous avoir procuré autant de plaisir à lire ceci que j'en ai eu à l'écrire.&nbsp;:)

