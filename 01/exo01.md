# Initiation à la programmation... avec la NASA

Pour cette initiation à la programmation pas vraiment comme les autres, nous
allons nous baser sur un exemple concret, à base de NASA et d'exoplanètes&nbsp;!

## Initiation

C'est une initiation pour aspirants codeurs, mais qui demande tout de même d'être familier avec quelques outils dont le Terminal.

L'idée c'est: vous vous sentez prêt à apprendre mais ne savez pas par quoi commencer&nbsp;? Alors jetez-vous dans le feu avec moi&nbsp;!&nbsp;:)

### Un gros mot: API

Nous allons nous adresser à une [API](http://fr.wikipedia.org/wiki/Interface_de_programmation) de la NASA.

Une API est, pour résumer, la partie accessible programmaticalement d'une autre application que la votre. 

Et la votre "discute" avec cette API.

Dans notre cas, nous voulons nous initier à la programmation en utilisant une
API de la NASA, "Exo", qui s'intéresse aux exoplanètes.

Mais nous n'allons pas demander de login et mot de passe, ni entrer dans un
serveur à la main, rien de tout cela: nous allons *programmer*, créer une app.

Notre minuscule application va se connecter au serveur de la NASA, poser notre
question, récupérer la réponse, la traiter et l'afficher.

Ce tutorial se veut rapide et fun; pour aller dans ce sens, j'expliquerai
quelques notions de base, mais irai, également, rapidement à l'essentiel&nbsp;: si vous ne comprenez pas un terme ou un concept, pas de panique, cherchez sur ce blog et sur le Web puis revenez ici.&nbsp;:)

### Un autre: JSON

Le serveur de la NASA (nous utiliserons désormais son nom&nbsp;: EXO) va nous
répondre avec un format bien précis: le [JSON](http://fr.wikipedia.org/wiki/JSON).

C'est-à-dire que nous n'allons pas obtenir ni des pages web ni des fichiers mais du texte, organisé par un protocole précis.

Ce format, le `JSON`, permet de représenter des données de façon sérialisée. 

Mais vous allez voir, c'est très simple.

Imaginons que votre app demande à l'API de l'IMdB ("Internet Movie DataBase") de lui fournir deux films d'après certains critères; voici ce que pourrait être sa réponse au format JSON&nbsp;:

```json
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

Chaque objet est délimité par `{}`. 

Des containers représentés par `[]` peuvent contenir plusieurs objets. 

On sépare les éléments avec `,` et `:`.

On peut aussi représenter l'exemple précédent de manière compacte:

```
{'meta':{'code':200,'message':'ok'},'data':[{'title':'2001 A space odyssey','year':1968},{'title':'Back to the Future','year':1985}]}
```  

C'est exactement le même contenu.

Et c'est typiquement une réponse de serveur en JSON&nbsp;: un champ 'meta' qui décrit l'état de la réponse (code de succès ou échec, taille des éléments de la réponse, type du serveur, etc) et un champ 'data' qui décrit le contenu de la réponse.

Le champ 'data' contient un groupe d'objets (deux dans notre exemple) contenant chacun un champ 'title' et un champ 'year'.


## Notre application

La première mouture de notre application peut se décrire en français:

```
Se connecter au serveur [EXO](http://exoapi.com) de la NASA
Demander quelles exoplanètes ont-elles été découvertes en l'an 2000
Récupérer la réponse au format JSON
Trier les objets fournis
Afficher les objets de notre choix
```  

Nous allons essayer de coder ça en Ruby *et* en Python, indifféremment, histoire d'explorer ces deux langages.

Si vous ne savez pas par quel langage commencer l'apprentissage de la programmation et que, comme tout le monde, vous êtes attirés par Ruby et Python...

...peut-être cet article saura-t-il vous aider à sauter le pas&nbsp;!

## Python et Ruby

Python et Ruby sont des langages de programmation scriptés, c'est-à-dire qu'ils se déroulent de haut en bas dans le sens du code, une ligne après l'autre en quelque sorte.

Il n'y a pas de dernière étape de "compilation" pour transformer le code en exécutable machine: ça se fait à la volée, au fur et à mesure.

On ne transforme pas le code en application: pour résumer, le code *est* l'application.

Ces deux langages sont très proches l'un de l'autre dans leur fonctionnement; ils sont tous les deux "orienté objet".

Cela signifie que les blocs de code manipulent des objets, des abstractions, et ces objets peuvent émettre et recevoir des messages - qui sont aussi des objets.

N'ayez pas peur, ça va s'éclaircir très vite, prenons pour ça un exemple tout simple.

## Exemple basique

Le fameux [Hello World](http://fr.wikipedia.org/wiki/Hello_World). 

Principe&nbsp;: on veut afficher "Hello World!" à l'écran.

Mais au lieu de m'en tenir à l'explication des mécanismes de base, comme le font tous les tutoriels, je vais directement vous plonger dans le grand bain. 

On va apprendre à toute vitesse&nbsp;!

### Objets, classes, méthodes

Nous allons créer un gros objet que l'on nomme une "classe".

Cette classe comprendra plusieurs petits objets, qui seront des "méthodes". 

Ces méthodes sont des définitions d'objets qui remplissent chacun un rôle précis.

**On va ici créer pour l'exemple une classe `Saluer` qui va contenir la méthode `dire_bonjour`, mais qui pourrait aussi contenir une méthode `dire_au_revoir`, une méthode `serrer_la_main`, etc.**

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

Bon alors, c'est simple et c'est compliqué en même temps. 

Tout d'abord, on remarque que le code est indenté.

![Indentation](https://files.app.net/2x68zc8wk.png)

C'est une manière de représenter la hiérarchie du code.

Ici, on *voit* que l'instruction 

`puts "Hello World!"` 

se trouve à l'intérieur de la méthode (définition) 

`dire_bonjour`

qui se trouve à l'intérieur de la classe 

`Saluer`.

En revanche, les deux dernières lignes ne sont pas indentées, elles restent au niveau racine du script&nbsp;: elles ne font pas partie de la classe.

*En Ruby, l'indentation est la plupart du temps cosmétique et n'a donc pas d'autre importance que la lisibilité du script... mais il est cependant important de respecter ces conventions.*

Pour faire une indentation, tapez la touche `TAB` sur votre clavier. 

Si votre éditeur de code est bien réglé, chaque TAB sera transformée, pour Ruby, en deux espaces (également par convention).

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

Savez-vous deviner ce que fait ce script&nbsp;?

Allons-y ligne par ligne (sur `exo1a.rb`).

1: nous créons la classe `Saluer`. A cette ouverture correspond une fermeture avec le mot-clé `end`:

```ruby
class Saluer
end
```  

2: dans la classe, nous créons la méthode `dire_bonjour`. Pareil, il faut fermer avec `end`:

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

Pour le moment, notre classe ne fait rien&nbsp;: elle est juste définie. 

Elle est *capable* de dire "Hello World!" car elle contient une méthode qui contient cette instruction, mais ne *fait* encore rien.

Si vous enregistrez ces lignes dans un fichier `saluer.rb` ('rb' est l'extension pour Ruby) et si vous l'exécutez, rien ne se passe.

Pour exécuter ce script Ruby, faites&nbsp;:

`> ruby saluer.rb`

dans le Terminal (en étant dans le même dossier que votre script).

*Le ">" est là pour indiquer une commande à taper dans le Terminal, ne le tapez pas...&nbsp;:)*

Rien ne s'affiche et c'est normal&nbsp;: l'instruction pour afficher est bien là mais elle est définie sous forme d'objet, et cet objet ne fait rien. Ou plutôt, on ne lui fait encore rien faire...

Pour exécuter l'instruction "dire bonjour" qui se trouve dans la classe `Saluer`, on va *instancier* la classe dans un objet, on peut presque dire qu'on va incarner cette classe&nbsp;:

```
action = Saluer.new
```  

**On dit ici à Ruby&nbsp;: tu prends la classe `Saluer`, et tu en crées une nouvelle instance dans un nouvel objet nommé `action`.**

Cet objet `action` contient désormais en lui la méthode "dire bonjour", que l'on peut alors appeler. Comment&nbsp;?

Avec un `.` (un point) comme on vient de faire avec `new`&nbsp;:

```ruby
action.dire_bonjour
```  

Ici, on appelle la méthode (la fonction) `dire_bonjour` qui est contenue dans l'objet `action`.

Et là, s'affiche notre phrase dans le Terminal&nbsp;!

## Mais... pourquoi ?!

N'aurait-on pas pu simplement écrire UNE ligne de code&nbsp;? Comme ceci&nbsp;:

```ruby
puts "Hello World!"
```  

Euh, oui. En effet. :)

Mais alors ce script à une ligne ne ferait qu'une seule chose, et ne la ferait que dans son propre contexte, sans modification possible; alors qu'en créant une classe qui contient cette instruction, on permet la modularité et la réutilisation.

Dans notre cas, avec la NASA, on ne va pas faire UN script qui pose une question, puis un AUTRE script qui pose une autre question: on va faire un script avec UNE classe qui contient LES méthodes pour poser des questions.

Ensuite, on va appeller les méthodes de cette classe, pour qu'elles traitent les infos retournées par EXO.

## Ligne de commande

Pour rester simple, notre application sera en ligne de commande. Elle va s'exécuter dans le [Terminal](http://aya.io/blog/terminal-console-cli/).

On tapera le nom de notre app, puis une donnée. 

Par exemple, pour savoir quelles exoplanètes ont été découvertes en l'an 2000, on fera&nbsp;:

```
ruby exoplanetes.rb 2000
```  

Cela signifie que notre script ici nommé "exoplanetes.rb" devra être capable de *recevoir* des données de la part de l'utilisateur&nbsp;: ici, le nombre 2000.

Heureusement, c'est déjà prévu dans Ruby. Ca prend la forme d'une constante nommée 

`ARGV`

qui contient la ou les données dans un container.

Avec 

`ruby exoplanetes.rb 2000`

la constante ARGV contient&nbsp;: 

`['2000']`

Si l'on faisait 

`ruby exoplanetes.rb 2000 2001 2002`

ARGV contiendrait&nbsp;: 

`['2000', '2001', '2002']`

## Structures: tableau

Qu'est-ce que c'est que ce `['2000', '2001', '2002']`&nbsp;?

En Ruby on appelle cette structure un tableau (Array).

*C'est juste un container à éléments*. 

On peut mettre ce qu'on veut dedans. Exemples d'arrays&nbsp;:

```ruby
prénoms = ['Eric', 'Alice', 'Nicolas', 'Abed', 'John-Paul']
emails = ['eric@aya.io', 'alice@disney.com']
scores = [33, 12, 8192, 111111, 23423847, 73]
todo_list = ['ranger chambre', 'call 0605040302', 'savon, shampooing, PQ']
mes_tableaux = [prénoms, emails, scores, todo_list]
```  

Et ensuite, comment récupérer ces infos&nbsp;?

Si l'on en veut qu'une, on peut l'attraper par son numéro d'index&nbsp;: 

`puts prénoms[0]` 

donnera 'Eric'.

C'est-à-dire que ça va afficher (`puts`) le premier prénom du tableau (car d'index `0`).

Pour le deuxième prénom&nbsp;? 

`prénoms[1]`

donnera 'Alice'.

Pour le troisième&nbsp;? 

`prénoms[2]`

donnera 'Nicolas'.

*Le fait que l'index commence à zéro est troublant mais on s'habitue vite.*

Si je fais 

`todo_list[2]`

j'obtiens&nbsp;: 

`'savon, shampooing, PQ'`

Dernier exemple&nbsp;:

`mes_tableaux[1][0]`

donne

`'eric@aya.io'`

Oui, ça marche comme ça pour les *tableaux imbriqués*. 

`mes_tableaux[1]` renvoie le tableau `emails`, et l'index `[0]` de ce tableau est `'eric@aya.io'`&nbsp;: voilà le sens de ce `mes_tableaux[1][0]`.

Et donc, pour notre ARGV&nbsp;? Ben si l'utilisateur ne demande qu'une année, elle sera automatiquement en première position, donc d'index `0`.

`puts ARGV[0]`

affichera le contenu du premier champ du tableau ARGV, et donc dans notre cas l'année demandée par l'utilisateur.

## Structures: dictionnaire

Il y a de nombreuses structures disponibles, et pour le moment nous n'avons vu que le tableau (ou 'Array'). Et encore, on l'a aperçu... mais ça suffit pour nos besoins actuels.

Je dois en présenter une autre avant d'aller plus loin, même si on ne va pas s'en servir de suite&nbsp;: le dictionnaire, ou en Ruby le "hash".

Alors qu'un tableau contient une suite d'éléments uniques, un hash contient une suite d'éléments par paires, et ces paires sont des clés/valeurs.

Comme dans un vrai dictionnaire, où chaque clé "mot" correspond à une valeur "définition du mot".

Et en Ruby comme en Python, un dictionnaire s'écrit... comme du JSON, entre `{` et `}`. 

A la différence qu'en Ruby il n'y a pas `:` entre la clé et la valeur mais `=>`.

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

C'est le même principe que pour les tableaux, mais au lieu de `[index]` on a `['clé']` pour retrouver les valeurs.

Au passage, on vient de voir que `+` en Ruby n'est pas fait que pour le calcul.&nbsp;:)

*Rappel&nbsp;: vous vous souvenez qu'on appelle des méthodes sur des objets via un point&nbsp;?*

En Ruby tout est objet, et la plupart des objets ont déjà plein de méthodes prédéfinies par le langage.

Par exemple, ici on va transformer 'eric' en 'Eric' en appellant la méthode `capitalize` sur l'objet chaîne de caractères `prénom` du dictionnaire `moi`.

**exo1d.rb**

```ruby
moi = {'âge' => 40, 'prénom' => 'eric', 'sexe' => 'non mais oh'}

puts "Mon prénom est " + moi['prénom'].capitalize
```  

Le code

`moi['prénom']` 

représente la valeur "eric", donc une fois qu'on appelle la méthode `capitalize` dessus, ça donne "Eric".

Le résultat du script `exo1d.rb` est:

`Mon prénom est Eric`

On peut appeler la méthode `capitalize` sur du texte car elle fait partie des nombreuses méthodes déjà inclues par Ruby pour ce type d'objet.

Dernier point&nbsp;: vous avez remarqué que certaines valeurs sont des chaînes de caractères (elles sont entre guillemets simples ou doubles), autrement dit du texte, et que d'autres sont des valeurs numériques, des nombres.

Un nombre n'est pas la même chose que sa représentation textuelle.

`40` est différent de `'40'`

Le premier est un nombre, le deuxième est une chaîne de caractères qui représente ce nombre.

Avec notre exemple, si vous faites&nbsp;:

```ruby
moi = {'âge' => 40, 'prénom' => 'eric', 'sexe' => 'non mais oh'}

puts "J'ai " + moi['âge'] + " ans"
```  

alors Ruby va râler parce qu'il ne sait pas ajouter un nombre au milieu d'une chaîne de caractères.

Il faut transformer le nombre en texte qui le représente, et pour cela on appelle sur cet objet nombre la méthode "to_s" (qui signifie "to string")&nbsp;:

```ruby
moi = {'âge' => 40, 'prénom' => 'eric', 'sexe' => 'non mais oh'}

puts "J'ai " + moi['âge'].to_s + " ans"
```  

Il y a d'autres manières de s'y prendre mais ceci me semblait necessaire pour la suite.

Bon, fini la théorie, allons coder notre app&nbsp;!

## Récupérer une info de l'utilisateur

Commençons par vérifier qu'on sait bien comment récupérer ce que demande l'utilisateur.

On a dit qu'on voulait récupérer une année, par exemple 2000.

Alors commencons par ne faire que ça, mais dans une structure capable d'évoluer par la suite&nbsp;:

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

Ah&nbsp;! Il y a là pas mal de nouveautés. Mais c'est plutôt simple, suivez le guide...

Commençons par les deux dernières lignes. Que voit-on&nbsp;? 

Une classe, que nous avons définie au début du script, est instanciée *avec un paramètre* (ce paramètre est `ARGV`) dans un objet nommé `exo`, puis une méthode (`what_year`) de cette classe est appellée sur cet objet.

Avant nous avions fait 

`MaClasse.new`

maintenant nous faisons 

`MaClasse.new(mon_paramètre)` 

pour instancier la classe avec, déjà, au départ, une valeur.

Cette valeur c'est dans notre exemple `ARGV`, qui souvenez-vous est une constante qui contient ce que l'utilisateur a demandé sur la ligne de commande.

La classe récupère cette valeur lors de son instanciation et la fait sienne grâce à la méthode nommée `initialize`.

La méthode `initialize` prend un paramètre, étiquetté ici `params` dans sa définition, mais j'aurais pu le nommer comme bon me semble, genre 'chameau' ou 'fesse'. Mais bon... il vaut mieux s'efforcer de toujours être explicite et dans le contexte.&nbsp;:)

Le contenu de ce paramètre (chez nous ce sera donc ARGV lors de l'instanciation) est transféré dans une variable dite *variable d'instance* (car elle est accessible par toutes les méthodes de l'objet instancié), qui est représentée par 

`@year`

(en Ruby, les variables d'instance s'écrivent avec un '@' devant leur nom.)

L'instruction

`exo = NasaExo.new(ARGV)` 

signifie donc&nbsp;: 

**dis Ruby, crée je te prie une nouvelle instance de la classe `NasaExo` dans la variable `exo`, et initialise au passage à l'intérieur de cette instance une variable `@year` à partir du contenu de `ARGV`.**

Ensuite nous voyons que la méthode `initialize` dans notre classe ne fait pas que transférer la valeur `ARGV` dans la variable `@year` en passant par le paramètre `params`: elle en prend le premier élément du tableau (`params[0]`).

*Je résume: `ARGV`, qui contient un tableau, est passé à la classe `NasaExo` qui s'instancie avec une variable contenant la première valeur de ce tableau.*

C'est pas clair&nbsp;? Regardez cet autre exemple&nbsp;:

```ruby
class JeParleToutSeul
  def initialize
    puts "Héhé ahah ohoh"
  end
end
```  

Si vous instanciez la classe avec par exemple 

`maclasse = JeParleToutSeul.new`

la phrase "Héhé ahah ohoh" sera affichée&nbsp;! Alors que nous n'avons pas encore appelé de méthode&nbsp;!

C'est que "initialize", si présent, est *toujours* exécuté lors de l'instanciation d'une classe, tout simplement. Et avec une valeur&nbsp;?

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

Exécutez `exo2.rb` en lui donnant une année en paramètre&nbsp;:

```
> ruby exo2.rb 2014
```  

Vous devriez voir : 

`L'année demandée est: 2014`

Sinon, c'est qu'il y a un Gremlin quelque part...

Rappel du principe que nous venons d'étudier&nbsp;:

*Classe contenant le code => instanciation dans un objet => transfert de ARGV[0] dans @year => appel d'une méthode qui affiche un texte puis le contenu de @year*

Si ça marche, et que vous avez suivi sans trop décrocher... BRAVO&nbsp;!!! 

Le plus dur est fait ! Je ne plaisante pas. Si vous avez compris tout ça, vous savez déjà programmer en Ruby. 

Je veux dire: vous savez faire un pas, donc vous allez savoir marcher bientôt, et même courir.&nbsp;:)

## J'veux des planètes !

Au prochain épisode. :)

J'ai beaucoup détaillé au début pour dégrossir, la prochaine fois on va accélérer un peu et ainsi vite arriver à notre vraie app.

Après nos exercices, on peut maintenant reformuler notre app en français&nbsp;:

```
1. Récupérer une année indiquée par l'utilisateur, par exemple 2012
2. Se connecter au serveur EXO de la NASA
3. Demander quelles exoplanètes ont été découvertes cette année-là
4. Récupérer la réponse au format JSON
5. Trier les éléments fournis
6. Gérer les éventuelles erreurs
7. Préparer un affichage avec ce qui nous intéresse
```  

## Résumé

Nous avons vu qu'il est bon de créer son code dans une ou plusieurs classes.

Ces classes sont un peu des "blueprint", des plans d'architecte: si l'on veut obtenir le vrai bâtiment il faut "instancier" la classe dans un objet.

Ensuite cet objet devient capable de répondre si on appelle les méthodes (définitions) de sa classe.

Cet objet peut traiter des données, que l'on stocke dans des structures en mémoire: des variables, des constantes, des tableaux, des dictionnaires, etc.

On manipule des objets qui se passent des messages entre eux... sous forme d'objets.

Si c'est encore un peu abstrait/étrange c'est bien normal, et puis nous n'avons fait qu'effleurer ces concepts, sous forme simplifiée...

Rendez-vous au prochain article pour faire monter la température&nbsp;!
