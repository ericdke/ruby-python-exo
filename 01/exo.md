# Initiation à la programmation... avec la NASA

Pour cette initiation à la programmation pas vraiment comme les autres, nous
allons nous baser sur un exemple concret, à base de NASA et d'exoplanètes&nbsp;!

## Initiation

C'est une initiation pour aspirants codeurs, mais qui demande tout de même d'être familier avec quelques outils dont le Terminal.

L'idée c'est: vous vous sentez prêt à apprendre mais ne savez pas par quoi commencer ? Alors jetez-vous dans le feu avec moi ! :)

### Un gros mot: API

Nous allons nous adresser à une API de la NASA.

Une APi est un peu la partie accessible, programmaticalement, d'une autre application que la votre. Et la votre "discute" avec cette API.

Dans notre cas, nous voulons nous initier à la programmation en utilisant une
API de la NASA. 

Celle-ci met à notre disposition de nombreux serveurs contenant
de nombreuses informations; nous allons utiliser celui qui s'intéresse aux
exoplanètes.

Mais nous n'allons pas demander de login et mot de passe, ni entrer dans un
serveur à la main, rien de tout cela: nous allons *programmer*, créer une app.

Notre minuscule application va se connecter au serveur de la NASA, poser notre
question, récupérer la réponse, la traiter et l'afficher.

Ce tutorial se veut rapide et fun; pour aller dans ce sens, j'expliquerai
quelques notions de base, mais irai, également, rapidement à l'essentiel: si vous ne comprenez pas un terme ou un concept, pas de panique, cherchez sur ce blog et sur le Web puis revenez ici. :)

### Un autre: JSON

Le serveur de la NASA (nous utiliserons désormais son nom: EXO) va nous
répondre avec un format bien précis: le JSON.

C'est-à-dire que nous n'allons pas obtenir ni des pages web ni des fichier mais du texte, organisé par un protocole précis.

Ce format, le JSON, permet de représenter des données de façon sérialisée. Mais
vous allez voir c'est très simple.

Exemple de réponse JSON du genre Internet Movie DataBase:

```
{
  'meta': {
    'code': 200,
    'message': 'Movie titles with release years'
  },
  'data': [
      {
        'title': '2001 A space odyssey',
        'year': 1968
      },
      {
        'title': 'Back to the Future',
        'year': 1985
      }
  ]
}
```  

Chaque objet est délimité par `{}`. Des containers représentés par `[]` peuvent contenir plusieurs objets dans la même section. On sépare les éléments avec ',' et ':'.

On peut aussi avoir l'exemple précédent de manière compacte:

```
{'meta':{'code':200,'message':'ok'},'data':[{'title':'2001 A space odyssey','year':1968},{'title':'Back to the Future','year':1985}]}
```  

C'est exactement la même chose.

Et c'est typiquement une réponse de serveur en JSON: un champ 'meta' qui décrit l'état de la réponse (succès, échec, taille, etc) et un champ 'data' qui décrit le contenu de la réponse.

Ici, le champ 'meta' contient un champ 'code' qui contient un nombre, le code de la réponse (nous y reviendrons plus tard), et un champ 'message' qui contient une chaîne de caractères décrivant la réponse.

Ensuite, le champ 'data' contient un groupe d'objets (ici, deux) contenant chacun un champ 'title' et un champ 'year'.


## Notre application

La première mouture de notre application peut se décrire en français:

```
Se connecter au serveur EXO de la NASA
Demander des infos, par exemple quelles exoplanètes ont-elles été découvertes en l'an 2000
Récupérer la réponse au format JSON
Trier les éléments fournis, au besoin les modifier
Afficher les éléments de son choix
```  

Nous allons essayer de coder ça en Ruby *et* en Python, indifféremment, histoire d'explorer ces deux langages.

Je connais bien Ruby, mais je suis encore amateur en Python, donc ça devrait être amusant... et instructif.

Si par exemple vous ne savez pas par quel langage commencer l'apprentissage de la programmation et que, comme tout le monde, vous voulez commencer par un langage "facile", vous hésitez forcément entre ces deux-là...

Peut-être cet article saura-t-il vous aider à sauter le pas !

## Python et Ruby

Python et Ruby sont des langages de programmation scriptés, c'est-à-dire qu'ils se déroulent de haut en bas dans le sens du code, une ligne après l'autre en quelque sorte.

Il n'y a pas de dernière étape de "compilation" pour transformer le code en exécutable machine: ça se fait à la volée, au fur et à mesure.

On ne transforme pas le code en application: le code *est* l'application.

Ces deux langages sont très proches l'un de l'autre dans leur fonctionnement; ils sont tous les deux "orienté objet".

Cela signifie que les blocs de code manipulent des objets, des abstractions, et ces objets peuvent émettre et recevoir des messages - qui sont aussi des objets.

N'ayez pas peur, ça va s'éclaircir très vite, prenons pour ça un exemple simplissime.

## Exemple _presque_ super basique

Le fameux Hello World. 

Principe: on veut afficher "Hello World!" à l'écran.

Mais au lieu de m'en tenir à l'explication des mécanismes de base, comme le font tous les tutoriels, je vais directement vous plonger dans le grand bain. 

On va apprendre à vitesse grand V, ça va chier !

### Objets, classes, méthodes

Nous allons créer un gros objet que l'on nomme une "classe".

Cette classe comprendra plusieurs petits objets, qui seront des "méthodes". 

Ces méthodes sont des définitions d'objets qui remplissent chacun un rôle précis.

**On va ici créer pour l'exemple une classe "Saluer" qui va contenir la méthode "dire_bonjour", mais qui pourrait aussi contenir une méthode "dire_au_revoir", une méthode "serrer_la_main", etc.**

Allons-y. En Ruby, tiens, pour voir. On fera du Python la prochaine fois.

**exo1a.rb**

```ruby
class Saluer
  def dire_bonjour
    puts "Hello World!"
  end
end

action = Saluer.new

action.dire_bonjour
```  

Bon alors, c'est simple et c'est compliqué en même temps. Voyons ce qu'il se passe.

Tout d'abord, on remarque que le code est identé.

![Identation](https://files.app.net/2x68zc8wk.png)

C'est une manière de représenter la hiérarchie du code.

Ici, on *voit* que l'instruction 

`puts "Hello World!"` 

se trouve à l'intérieur de la méthode (définition) 

`dire_bonjour`

qui se trouve à l'intérieur de la classe 

`Saluer`.

En revanche, les deux dernières lignes ne sont pas identées, elles restent au niveau racine du script.

*En Ruby, l'indentation est la plupart du temps cosmétique et n'a donc pas d'autre importance que la lisibilité du script... mais c'est cependant important de respecter ces conventions.*

Pour faire une identation, tapez la touche `TAB` sur votre clavier. Si votre éditeur de code est bien réglé, chaque TAB sera transformée, pour Ruby, en deux espaces (pour Python nous en reparlerons plus tard).

Avant d'expliquer la suite je vais rajouter une méthode dans la classe, ainsi qu'une instruction à la fin:

**exo1b.rb**

```ruby
class Saluer

  def dire_bonjour
    puts "Hello World!"
  end

  def dire_au_revoir
    puts "Good bye..."
  end

end

action = Saluer.new

action.dire_bonjour

action.dire_au_revoir
```  

Savez-vous deviner ce que fait réellement ce script ? Même si vous ne comprenez pas trop, lisez-le plusieurs fois, analysez son contenu: on voit une classe, des "def", des "puts"... mais que sont ces choses ?

Allons-y ligne par ligne (sur exo1a.rb).

1: nous créons la classe "Saluer". A cette ouverture correspond une fermeture avec le mot-clé "end":

```ruby
class Saluer
end
```  

2: dans la classe, nous créons la méthode "dire_bonjour". Pareil, il faut fermer avec "end":

```ruby
class Saluer
  def dire_bonjour
  end
end
```  

3: dans cette méthode, nous donnons l'instruction d'afficher une chaîne de caractères, avec la commande `puts`, cette chaîne étant notre texte:

```ruby
class Saluer
  def dire_bonjour
    puts "Hello World!"
  end
end
```  

Pour le moment, notre classe ne fait rien: elle est juste définie. 

Elle est *capable* de dire "Hello World!" car elle contient une méthode qui contient cette instruction, mais ne *fait* encore rien.

Si vous enregistrez ces quatre lignes dans un fichier `saluer.rb` ('rb' est l'extension pour Ruby) et si vous l'exécutez, rien ne se passe.

Pour exécuter ce script Ruby, faites:

`> ruby saluer.rb`

dans le Terminal (en étant dans le même dossier que votre script).

*Le ">" est là pour indiquer une commande à taper dans le Terminal, ne le tapez pas... :)*

Rien ne s'affiche et c'est normal: l'instruction pour afficher est bien là mais elle est définie sous forme d'objet, et cet objet ne fait rien. Ou plutôt, on ne lui fait encore rien faire...

Pour exécuter l'instruction "dire bonjour" qui se trouve dans la classe "saluer", on va *instancier* la classe dans un objet, on peut presque dire qu'on va incarner cette classe:

```
action = Saluer.new
```  

**On dit ici à Ruby: tu prends la classe Saluer, et tu en crées une nouvelle instance dans un nouvel objet nommé 'action'.**

Cet objet 'action' contient désormais en lui la méthode "dire bonjour", que l'on peut alors appeler. Comment ?

Avec un `.` (un point) comme on vient de faire avec 'new':

```ruby
action.dire_bonjour
```  

Ici, on appelle la méthode (la fonction) "dire_bonjour" qui est contenue dans l'objet action.

Et là, s'affiche notre phrase dans le Terminal !

## Mais... pourquoi?!

N'aurait-on pas pu simplement écrire UNE ligne de code? Comme ceci:

```ruby
puts "Hello World!"
```  

Euh, oui. En effet. :)

Mais alors ce script à une ligne ne ferait qu'une seule chose, et ne la ferait que dans son propre contexte, sans modification possible; alors qu'en créant une classe qui contient cette instruction, on permet la modularité et la réutilisation.

Dans notre cas, avec la NASA, on ne va pas faire UN script qui pose une question, puis un AUTRE script qui pose une autre question: on va faire un script avec UNE classe qui contient LES méthodes pour poser des questions.

Ensuite, on va appeller les méthodes de cette classe, pour qu'elles traitent les infos retournées par EXO.

## Ligne de commande

Pour rester simple, notre application sera en ligne de commande. Elle va s'exécuter dans le Terminal.

On tapera le nom de notre app, puis une donnée. Par exemple, pour savoir quelles exoplanètes ont été découvertes en l'an 2000, on fera:

```
ruby exo.rb 2000
```  

Cela signifie que notre script ici nommé "exo.rb" doit être capable de *recevoir* des données de la part de l'utilisateur: ici, le nombre 2000.

Heureusement, c'est déjà prévu dans Ruby. Ca prend la forme d'une constante nommée 

`ARGV`

qui contient la ou les données dans un container.

Avec 

`ruby exo.rb 2000`

la constante ARGV contient: 

`['2000']`

Si l'on faisait 

`ruby exo.rb 2000 2001 2002`

ARGV contiendrait: 

`['2000', '2001', '2002']`

## Structures: tableau

Qu'est-ce que c'est que ce `['2000', '2001', '2002']` ?

En Ruby on appelle cette structure un tableau (Array).

*C'est juste un container à éléments*. 

Il en existe de nombreuses autres sortes. On peut mettre ce qu'on veut dedans. Exemples d'arrays:

```ruby
prénoms = ['Eric', 'Alice', 'Nicolas', 'James', 'Nico']
emails = ['eric@aya.io', 'alice@disney.com']
scores = [33, 12, 8192, 111111, 23423847, 73]
todo_list = ['ranger chambre', 'call 0605040302', 'savon, shampooing, PQ']
```  

Et ensuite, comment récupérer ces infos ?

Si l'on en veut qu'une, on peut l'attraper par son numéro d'index: 

`puts prénoms[0]` 

va afficher (`puts`) le premier prénom du tableau (car d'index `0`).

Pour le deuxième prénom? 

`prénoms[1]`

Pour le troisième? 

`prénoms[2]`

*Le fait que l'index commence à zéro est troublant mais on s'habitude vite.*

Si je fais 

`todo_list[2]`

j'obtiens: 

`'savon, shampooing, PQ'`

Et donc, pour notre ARGV? Ben si l'utilisateur ne demande qu'une année, elle sera automatiquement en première position, donc d'index `0`:

`puts ARGV[0]`

affichera le contenu du premier champ du tableau ARGV, et donc dans notre cas l'année demandée par l'utilisateur.

## Structures: dictionnaire

Il y a de nombreuses structures disponibles, et pour le moment nous n'avons vu que le tableau (ou 'Array'). 

Je dois en présenter une autre avant d'aller plus loin: le dictionnaire, ou en Ruby le "hash".

Alors qu'un tableau contient une suite d'éléments uniques, un hash contient une suite d'éléments par paires, et ces paires sont des clés/valeurs.

Comme dans un vrai dictionnaire, où chaque clé "mot" correspond à une valeur "définition du mot".

Et en Ruby comme en Python, un dictionnaire s'écrit... comme du JSON, entre "{" et "}", à la différence (pour simplifier) qu'il n'y a pas ":" entre la clé et la valeur mais "=>":

```ruby
moi = {'âge' => 40, 'prénom' => 'eric', 'sexe' => 'non mais oh'}
```  

En revanche pour accéder aux infos on n'utilise par d'index car un dictionnaire n'est pas ordonné. 

On utilise... les clés.

**exo1c.rb**
```ruby
moi = {'âge' => 40, 'prénom' => 'eric', 'sexe' => 'non mais oh'}

puts "Mon prénom est " + moi['prénom']
puts "Et on s'arrêtera là, " + moi['sexe']
```  

C'est le même principe que pour les tableaux, mais au lieu de [index] on a ['clé'].

Au passage, on vient de voir que "+" en Ruby n'est pas fait que pour le calcul. :)

*Rappel: vous vous souvenez qu'on appelle des méthodes sur des objets via un point ?*

En Ruby tout est objet, et la plupart des objets ont déjà plein de méthodes prédéfinies par le langage.

Par exemple, ici on va transformer 'eric' en 'Eric' en appellant la méthode 'capitalize' sur l'objet chaîne de caractères 'prénom' du dictionnaire 'moi'.

**exo1d.rb**
```ruby
moi = {'âge' => 40, 'prénom' => 'eric', 'sexe' => 'non mais oh'}

puts "Mon prénom est " + moi['prénom'].capitalize
```  

Le code

`moi['prénom']` 

représente "eric", donc une fois qu'on appelle `capitalize` dessus, ça donne "Eric".

Le résultat du script `exo1d.rb` est:

`Mon prénom est Eric`

Dernier point: vous avez remarqué que certaines valeurs sont des chaînes de caractères (elles sont entre guillemets simples ou doubles) et que d'autres sont des valeurs numériques, des nombres.

Un nombre n'est pas la même chose que sa représentation textuelle.

40 est différent de '40'

Le premier est un nombre, le deuxième est une chaîne de caractères qui représente ce nombre.

Avec notre exemple, si vous faites:

```ruby
moi = {'âge' => 40, 'prénom' => 'eric', 'sexe' => 'non mais oh'}

puts "J'ai " + moi['âge'] + " ans"
```  

alors Ruby va râler parce qu'il ne sait pas ajouter un nombre au milieu d'une chaîne de caractères.

Il faut transformer le nombre en texte qui le représente, et pour cela on appelle sur l'objet nombre la méthode "to_s" (qui signifie "to string"):

```ruby
moi = {'âge' => 40, 'prénom' => 'eric', 'sexe' => 'non mais oh'}

puts "J'ai " + moi['âge'].to_s + " ans"
```  

Il y a d'autres manières de s'y prendre mais ceci me semblait necessaire pour la suite.

Bon, fini la théorie, commençons à coder notre app !

## Récupérer une info de l'utilisateur

Commençons par vérifier qu'on sait bien comment récupérer ce que demande l'utilisateur.

On a dit qu'on voulait récupérer une année, par exemple 2000.

Alors commencons par ne faire que ça, mais dans une structure capable d'évoluer par la suite:

**exo2.rb**
```ruby
class NasaExo

  def initialize(params)
    @year = params[0]
  end

  def what_year
    puts "L'année demandée est: " + @year
  end

end

exo = NasaExo.new(ARGV)

exo.what_year
```  

Ah! Il y a là pas mal de nouveautés. Mais c'est plutôt simple, suivez le guide...

Commençons par les deux dernières lignes. Que voit-on? 

Une classe est instanciée *avec un paramètre* (ce paramètre est ARGV) dans un objet nommé 'exo', puis une méthode (what_year) de cette classe est appellée sur cet objet.

Avant nous avions fait 

`MaClasse.new`

maintenant nous faisons 

`MaClasse.new(mon_paramètre)` 

pour instancier la classe avec, déjà, au départ, une valeur.

Cette valeur c'est dans notre exemple `ARGV`, qui souvenez-vous est une constante qui contient ce que l'utilisateur a demandé sur la ligne de commande.

La classe récupère cette valeur lors de son instanciation et la fait sienne grâce à la méthode nommée 'initialize'.

La méthode 'initialize' prend un paramètre, étiquetté ici 'params' dans sa définition, mais j'aurais le nommer comme bon me semble, genre 'chameau' ou 'fesse'. Mais bon... il vaut mieux s'efforcer de toujours être explicite et dans le contexte. :)

Le contenu de ce paramètre (chez nous ce sera donc ARGV lors de l'instanciation) est transféré dans une variable dite *variable d'instance*, qui est représentée par 

`@year`

(les variables d'instance s'écrivent avec un '@' devant leur nom.)

La ligne 

`exo = NasaExo.new(ARGV)` 

signifie donc: 

**dis Ruby, crée je te prie une nouvelle instance de la classe NasaExo dans l'objet exo, et initialise au passage à l'intérieur de cette instance une variable qui contiendra la même chose que ARGV.**

Ensuite nous voyons que la méthode initialize dans notre classe ne fait pas que transférer la valeur 'ARGV' dans la variable '@year' en passant par le paramètre 'params': elle en prend le premier élément du tableau (params[0]).

*Je résume: ARGV, qui contient un tableau, est passé à la classe NasaExo qui s'instancie avec une variable contenant la première valeur de ce tableau.*

C'est pas clair? Regardez cet autre exemple:

```ruby
class JeParleToutSeul
  def initialize
    puts "Héhé ahah ohoh"
  end
end
```  

Si vous instanciez la classe avec par exemple 

`maclasse = JeParleToutSeul.new`

la phrase "Héhé ahah ohoh" sera affichée! Alors que nous n'avons pas encore appelé de méthode!

C'est que "initialize", si présent, est *toujours* exécuté lors de l'instanciation d'une classe, tout simplement. Et avec une valeur?

```ruby
class JeParleToutSeul
  def initialize(valeur)
    puts "Héhé ahah ohoh " + valeur
  end
end
```  

Vous instanciez avec par exemple 

`maclasse = JeParleToutSeul.new('hihi')` 

et vous obtenez la sortie "Héhé ahah ohoh hihi" automatiquement. 

*Bon, revenons à notre app.*

Exécutez `exo2.rb` en lui donnant une année en paramètre:

```
> ruby exo2.rb 2014
```  

Vous devriez voir : 

`L'année demandée est: 2014`

Sinon, c'est qu'il y a un Gremlin quelque part...

Rappel du principe que nous venons d'étudier:

*Classe contenant le code => instanciation dans un objet => transfert de ARGV[0] dans @year => appel d'une méthode qui affiche un texte puis le contenu de @year*

Si ça marche, et que vous avez suivi sans trop décrocher... BRAVO !!! 

Le plus dur est fait ! Je ne plaisante pas. Si vous avez compris tout ça, vous savez déjà programmer en Ruby. 

Je veux dire: vous savez faire un pas, donc vous allez savoir marcher bientôt, et même courir. :)

## J'veux des planètes !

Au prochain épisode. :)

J'ai beaucoup détaillé au début pour dégrossir, la prochaine fois on va accélérer un peu et ainsi vite arriver à notre vraie app.

Après nos exercices, on peut maintenant reformuler notre app en français:

```
1. Récupérer une année indiquée par l'utilisateur, par exemple 2012
2. Se connecter au serveur EXO de la NASA
3. Demander quelles exoplanètes ont été découvertes cette année-là
4. Récupérer la réponse au format JSON
5. Trier les éléments fournis
6. Préparer un affichage avec ce qui nous intéresse
7. Si demandé, enregistrer les résultats dans un fichier
```  

## Résumé

Nous avons vu qu'il est bon de créer son code dans une ou plusieurs classes.

Ces classes sont un peu des "blueprint", des plans d'architecte: si l'on veut obtenir le vrai bâtiment il faut "instancier" la classe dans un objet.

Ensuite cet objet devient capable de répondre si on appelle les méthodes (définitions) de sa classe.

Cet objet peut traiter des données, que l'on stocke dans des structures en mémoire: des variables, des constantes, des tableaux, des dictionnaires, etc.

On manipule des objets qui se passent des messages entre eux... sous forme d'objets.

Si c'est encore un peu abstrait/étrange c'est bien normal, et puis nous n'avons fait qu'effleurer ces concepts, sous forme simplifiée...

Rendez-vous au prochain article pour faire monter la température ! 
