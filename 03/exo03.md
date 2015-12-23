# Initiation à la programmation... avec la NASA

Pour cette initiation à la programmation pas vraiment comme les autres, nous
allons nous baser sur un exemple concret, à base de NASA et d'exoplanètes&nbsp;!

Si vous n'avez pas suivi, commencez donc au [premier chapitre]().

## Python = false; Ruby = true

Pour ce chapitre nous allons revenir à Ruby.

J'ai donc traduit notre précédent script&nbsp;: observez les différences, les points communs... 

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

Si vous exécutez ce script :

```text
> ruby exo2c.rb 2000
```  

vous obtenez exactement le même résultat qu'en Python.

Ligne 1 :

```ruby
#!/usr/bin/env ruby
```  

informe le système d'exploitation que le contenu de ce fichier est du Ruby exécutable. On n'a pas besoin d'approfondir ça pour le moment, mais ça vous servira plus tard.

Ligne 2 : comme on avait fait en Python, on a rajouté ici une ligne qui _force_ Ruby à utiliser l'encodage de caractères UTF-8.

Lignes 3 et 4 : on importe les modules pour traiter le JSON et pour se connecter au serveur.

Précision : il se peut que votre installation de Ruby ne contienne pas le module "rest client". Il faudra alors l'installer:

```ruby
> gem install rest-client
```  

Nous aurions pu utiliser le module Net/HTTP inclus dans Ruby mais cela aurait introduit des difficultés supplémentaires inutiles dans ce tuto. RestClient est plus simple à utiliser quand on débute (je ne détaillerai pas non plus ici son fonctionnement pour les mêmes raisons).

Ce module, donc, nous servira à créer une méthode perso `download` qui aura la même fonction que le module importé `urllib` de Python.

Ensuite on crée notre classe et nos méthodes (pas de parenthèses à la fin si pas de paramètres). 

J'ai ajouté dans la méthode d'initialisation une variable d'instance contenant la base de l'URL de EXO, exactement comme en Python.

Dans `get_planets`, ligne 2&nbsp;: on utilise donc notre propre méthode pour downloader à partir d'un serveur. 

Résumé : la variable `content` contient la réponse de la méthode `download` à qui l'on avait passé en paramètre l'URL du serveur construite auparavant.

Cette réponse étant du JSON, on la décode grâce au module importé puis on retourne la réponse à l'objet qui a appellé.

La méthode `get_names` fonctionne comme en Python, mais la syntaxe est différente.

D'abord on crée un tableau vide, ça c'est pareil.

Ensuite la ligne :

```ruby
planet_list.each do |planet|
```  

signifie "dans la liste `planet_list`, prends chaque élément et traite-le comme étant l'objet `planet`, merci".

`.each` est une méthode qui permet d'itérer sur des objets (il existe aussi la boucle "for" comme en Python mais "each" et ses confrères son plus Rubyesques).

On peut appliquer `.each` à tout objet énumérable: tableaux, dictionnaires, etc.

Ensuite on a&nbsp;:

```ruby
names << planet['name']
```  

qui signifie "injecte dans le tableau `names` la valeur de la clé `name` du dictionnaire `planet`" (`planet` étant chaque objet dans le tableau `planet_list` dans lequel nous sommes en train d'itérer).

Puis, comme en Python, on retourne le tableau `names` à qui l'a appellé.

Notre méthode `print_list` est identique à la version Python mais utilise la méthode `each` _de_ l'objet tableau au lieu d'utiliser une boucle `for` _sur_ l'objet tableau.

Voilà&nbsp;! Nous avons traduit notre code Python en Ruby.

J'ai volontairement gardé la même organisation que dans le script précédent pour pouvoir étudier et comparer plus facilement.

Mais ce script n'est du coup plus très Rubyesque, nous allons donc maintenant le remodeler un peu pour l'améliorer.

## Cent fois sur le métier...

Ruby propose de nombreuses aides syntaxiques pour obtenir du code propre et compact.

Nous allons transformer nos formules un peu lourdes en quelque chose de plus typiquement Ruby&nbsp;: non seulement ça va nous permettre d'apprendre à faire évoluer notre code pour le rendre plus modulaire, mais nous allons en profiter pour approfondir et/ou eclaircir certains concepts déjà vus.

**exo3a.rb**

```ruby
#!/usr/bin/env ruby
# encoding: utf-8
require 'json'
require 'rest_client'

class NasaExo

  def initialize(year)
    @year = year
    @api_base = 'http://exoapi.com/api/skyhook/'
  end

  def get_planets
    JSON.load(download(make_url_planets_year))['response']['results']
  end

  def get_names(planet_list)
    planet_list.map {|planet| planet['name']}
  end

  def print_list(my_list)
    my_list.each {|obj| puts obj}
  end

  def make_url_planets_year
    @api_base + 'planets/search?disc_year=' + @year
  end

  def download(url)
    RestClient.get(url) {|response, request, result| response}
  end

  def print_names
    print_list(get_names(get_planets))
  end

end

exo = NasaExo.new(ARGV[0])
exo.print_names
```  

Woah ! 

Voilà un truc que j'adore en Ruby&nbsp;: des méthodes courtes et compactes mais pourtant toujours lisibles.

Ceci dit il y a là *énormément* de changements, nous allons donc voir ça dans le détail.

Regardez à la fin du script&nbsp;: au lieu d'un enchaînement d'instructions, il n'y a plus que l'instanciation de la classe puis une seule instruction.

C'est pour aller dans le sens du principe suivant&nbsp;: c'est à la classe de manier les complexités, non pas à celui qui appelle la classe. 

Pour ce faire j'ai créé dans la classe une méthode `print_names` qui fait ce que l'on faisait nous-mêmes auparavant.

Il faut lire cette ligne de l'intérieur vers l'extérieur pour bien comprendre ce qui se passe&nbsp;:

```ruby
print_list(get_names(get_planets))
```  

On appelle la méthode `get_planets` qui renvoie une liste d'objets JSON décodés, chaque objet étant une planète&nbsp;; ce résultat est envoyé à `get_names` qui itère dans cette liste et extrait le nom de chaque planète&nbsp;; ce résultat est envoyé à `print_list` qui itère dans la liste de noms et affiche chaque objet (donc chaque nom). 

Ce résultat (l'affichage des noms) est lui-même renvoyé à l'appellant (`exo.print_names`).

Reprenons maintenant chaque méthode. Dans `get_planets`&nbsp;:

```ruby
JSON.load(download(make_url_planets_year))['response']['results']
```  

Là, l'idée c'est que nous avons la même chose que précédemment mais compacté en une seule ligne.

On part de l'intérieur des parenthèses&nbsp;: la méthode `make_url_planets_year` renvoie l'URL construite à l'aide des variables d'instance.

Mais regardez bien dans la méthode `make_url_planets_year`: il n'y a pas de `return`!

*Voilà un concept essentiel&nbsp;:*

**En Ruby, la dernière expression évaluée est toujours renvoyée.**

Dans cette méthode `make_url_planets_year`, il n'y a qu'une expression: 

```ruby
@api_base + 'planets/search?disc_year=' + @year
```  

et cette expression crée une chaîne de caractères qui représente l'URL, comme on l'a déjà vu.

Mais comme on est en Ruby, on n'a pas besoin de mettre `return` devant puisque c'est la dernière expression de la méthode&nbsp;: elle est donc retournée automatiquement.

Ceci est vraiment _très_ important pour Ruby.

Bon, ensuite cette url part dans notre méthode `download` qui va retourner ce qu'elle aura téléchargé. 

On découvre ici une nouvelle syntaxe, mais nous allons plutôt l'étudier sur le prochain exemple.

Cet objet qui est le 'téléchargement' part ensuite dans le décodeur JSON, qui renvoie le résultat&nbsp;: et de ce résultat on extrait directement les champs `['response']['results']` sans passer non plus par une variable intermédiaire.

Comme c'est la dernière chose évaluée, c'est ce qui est renvoyé à l'appellant&nbsp;: ça tombe bien, c'est ce qu'on veut et c'est fait exprès.&nbsp;:)

Si c'est pas clair, comparez cette version avec la précédente en les mettant l'une à côté de l'autre sur votre écran, et essayez de suivre mentalement le chemin des objets.

Pour s'entraîner il n'est pas ridicule de le faire à voix haute, par exemple&nbsp;: "alors cette ligne appelle ça qui le renvoie ici, ça appelle cet objet qui envoie le résultat dans cette méthode qui en prend chaque élément puis..."

Dans la version précédente, par souci de lisibilité et de compréhension, on mettait chaque résultat dans une variable puis on passait cette variable à la méthode ou à l'objet suivant&nbsp;: désormais on se gênera pas pour imbriquer directement les méthodes et objets sans passer par des stockages intermédiaires.

Bien sûr il faut tout de même rester lisible et ne pas s'amuser à créer des one-liners façon matriochkas mandalesques pour faire le malin&nbsp;: *la compacité c'est bien, mais l'expressivité c'est mieux*.

Voyons maintenant la méthode `get_names`&nbsp;:

```ruby
planet_list.map {|planet| planet['name']}
```  

On a remplacé `.each` par `.map`. 

Voici l'explication&nbsp;:

Au lieu de créer une variable tableau vide puis d'itérer dans chaque objet de la liste pour en injecter le nom de planète dans cette variable puis de renvoyer cette variable (ouf!), nous allons directement _créer_ le contenu.

`.map` itère dans un objet énumérable tout comme le fait `.each` mais crée automatiquement un tableau et le remplit avec le résultat de chaque itération.

Cette ligne peut donc se lire ainsi&nbsp;: "dans la liste `planet_list`, itère sur chaque objet que tu nommes `planet` et récupères le champ `['name']` de cet objet pour le placer dans un tableau que tu renverras à la fin".

Cette ligne:

```ruby
planet_list.map {|planet| planet['name']}
``` 

est identique à

```ruby
names = []
planet_list.each {|planet| names << planet['name']}
names
``` 

qui est identique à 

```ruby
names = Array.new
planet_list.each do |planet|
  names << planet['name']
end
return names
``` 

# Exoplanètes

Il est grand temps d'avancer dans notre app et de lui rajouter des fonctions.&nbsp;:)

Nous allons extraire d'autres infos de la réponse de EXO (jusque là nous n'avons que les noms des planètes) et les stocker dans une structure qui fait proxy pour faciliter la manipulation.

Nous allons créer deux méthodes, une pour récupérer plein de trucs dans un dictionnaire et l'autre pour les afficher&nbsp;:

**exo3b.rb**

```ruby
#!/usr/bin/env ruby
# encoding: utf-8
require 'json'
require 'rest_client'

class NasaExo

  def initialize(year)
    @year = year
    @api_base = 'http://exoapi.com/api/skyhook/'
  end

  def get_planets
    JSON.load(download(make_url_planets_year))['response']['results']
  end

  def get_names(planet_list)
    planet_list.map {|planet| planet['name']}
  end

  def print_list(my_list)
    my_list.each {|obj| puts obj}
  end

  def make_url_planets_year
    @api_base + 'planets/search?disc_year=' + @year
  end

  def download(url)
    RestClient.get(url) {|response, request, result| response}
  end

  def print_names
    print_list(get_names(get_planets))
  end

  def make_details
    get_planets.map do |obj|
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
  end

  def print_details
    puts "\n"
    make_details.each do |planet_details|
      planet_details.each {|key, value| puts "#{key.capitalize.ljust(16)} #{value.to_s.capitalize}"}
      puts "\n"
    end
  end

end

exo = NasaExo.new(ARGV[0])
exo.print_details
```  

Yeah&nbsp;! Voilà enfin l'affichage prévu depuis le début&nbsp;! La liste des exoplanètes découvertes en l'an xxx, avec quelques infos sur chacune.

Voyons notre méthode `make_details`.

On itère sur le résultat de `get_planets`&nbsp;: c'est juste qu'on ne stocke pas d'abord ce résultat dans une variable pour itérer dessus, mais on travaille directement dedans.

On aurait pu faire&nbsp;:

```ruby
planets = get_planets()
planets.map do |obj|
```  

et c'était pareil.

Ici, `.map` va créer un tableau contenant un dictionnaire par planète&nbsp;: ce dico contiendra uniquement les infos qui nous intéressent sur chaque planète.

Notre méthode `print_details` itère sur le résultat renvoyé par notre méthode `make_details`, mais cette fois avec `.each` et sur plusieurs lignes avec la syntaxe `do |x| ... end`.

A l'intérieur de cette boucle il y a une autre boucle, de syntaxe compacte, qui elle pioche dans le dictionnaire chaque clé et chaque valeur et les affiche selon un certain protocole que nous allons étudier.

## Manipuler du texte

Analysons le contenu de la méthode `print_details`&nbsp;:

```ruby
puts "\n"
make_details.each do |planet_details|
  planet_details.each {|key, value| puts "#{key.capitalize.ljust(16)} #{value.to_s.capitalize}"}
  puts "\n"
end
```  

On affiche d'abord un retour à la ligne avec le caractère spécial `\n`.

Ensuite on itère dans la liste détaillée des planètes, et chaque objet planète se retrouve dans la variable `planet_details`.

On itère alors dans cet objet avec DEUX paramètres, puisque nous sommes en train d'itérer dans un dictionnaire qui contient non pas des éléments uniques mais des paires d'éléments (les couples clé/valeur).

Pour chaque couple clé/valeur, nous affichons une chaîne de caractères&nbsp;:

```ruby
"#{key.capitalize.ljust(16)} #{value.to_s.capitalize}"
```  

puis une autre ligne vide.

Voyons la construction de cette chaîne de caractères.

Le mécanisme

```ruby
nom = "Eric"
"Bonjour mon nom est #{nom}"
```  

donne "Bonjour mon nom est Eric".

`#{}` permet d'insérer le résultat d'expressions Ruby dans du texte.

On aurait pu faire également

```ruby
nom = "Eric"
"Bonjour mon nom est " + nom
```  

Donc si j'ai

```ruby
"La clé est: #{key.capitalize}"
```  

Ca signifie que j'applique la méthode `capitalize` sur la variable `key`, ça renvoie une string (chaîne de caractères) qui est *insérée* dans `"La clé est: "`.

La méthode `.ljust(16)` permet elle de garantir que la longueur minimale du texte renvoyé par l'objet sera de 16 caractères&nbsp;: ça permet d'afficher des colonnes tabulées.

Comme nous sommes en train d'itérer dans le dictionnaire que nous avons construit, je prends l'exemple de la première paire clé/valeur pour résumer&nbsp;:

![Itération avec deux valeurs](https://files.app.net/2xlkg9L3z.png)

D'autres manipulations intéressantes, pour être certain d'avoir compris certains concepts&nbsp;:

```ruby
nerv = "ah oui ".upcase
puts nerv * nerv.length

mots = "voici plusieurs mots".split(" ")
puts mots.inspect
puts mots.class
puts mots.join(",")

lettres = ['a', 'b', 'c', 'd', 'e']
chiffres = (1..5).to_a

couples = chiffres.zip(lettres)
couples.each {|a,b| puts "#{a} - #{b}\n\n"}
puts couples.inspect
print("\n** #{couples.flatten} **\n\n")

assoc = couples.to_h
puts assoc.keys
puts assoc.values

x = {
  'yes' => 'oui',
  'no' => 'non'
}
puts assoc.merge(x)

puts lettres.first
puts lettres.first.inspect
puts lettres[0..2].inspect
puts lettres[0...2]
puts lettres[-3..-1]
puts lettres[-3...-1].inspect

puts lettres.length
puts lettres[0..2].length
puts lettres[0...2].length

puts chiffres.map {|value| value * 2}
puts chiffres.inject {|value| value * 2}

wow = {
  'lettres' => lettres,
  'chiffres' => chiffres
}
puts wow.inspect
puts wow['lettres'][0]
puts wow['chiffres'].last
```  

Pour tester du Ruby, pas obligé d'enregistrer dans un fichier&nbsp;: vous pouvez utiliser 'IRB' (interactive Ruby).

Dans le Terminal, tapez `irb`&nbsp;: vous vous retrouvez dans une *console Ruby*. Tout ce que vous tapez désormais est du Ruby (tapez `quit` pour sortir).

Par exemple, vous y tapez&nbsp;:

```ruby
nerv = "ah oui ".upcase
``` 

puis

```ruby
puts nerv * nerv.length
``` 

et ainsi de suite&nbsp;: vous avez les opérations en temps réel.

Sinon vous pouvez bien sûr tout copier-coller dans un fichier et observer les résultats d'un coup, ça marche aussi.&nbsp;;)

## Conclusion

Je vous laisse vous entraîner&nbsp;: avec toutes ces nouvelles infos vous allez être capable de bien enrichir vous-même votre app.

Il nous manque cependant encore quelques éléments essentiels pour terminer cette initiation, que nous verrons lors du prochain chapitre... en Python&nbsp;!&nbsp;:)
