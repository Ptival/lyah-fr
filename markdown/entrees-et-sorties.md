% Entrées et Sorties

<div class="prev-toc-next">
<ul>
<li style="text-align:left">
<a href="creer-nos-propres-types-et-classes-de-types" class="prevlink">Créer nos propres types et classes de types</a>
</li>
<li style="text-align:center">
[Table des matières](chapitres)
</li>
<li style="text-align:right">
<a href="resoudre-des-problemes-fonctionnellement" class="nextlink">Résoudre des problèmes fonctionnellement</a>
</li>
</ul>
</div>

<img src="img/dognap.png" alt="pauvre chien" class="right"/>

Nous avons mentionné qu'Haskell était un langage fonctionnel pur. Alors que
dans des langages impératifs, on parvient généralement à faire quelque chose en
donnant à l'ordinateur une série d'étapes à exécuter, en programmation
fonctionnelle on définit plutôt ce que les choses sont. En Haskell, une
fonction ne peut pas changer un état, comme par exemple le contenu d'une
variable (quand une fonction change un état, on dit qu'elle a des *effets de
bord*). La seule chose qu'une fonction peut faire en Haskell, c'est renvoyer un
résultat basé sur les paramètres qu'on lui a donnés. Si une fonction est
appelée deux fois avec les mêmes paramètres, elle doit retourner le même
résultat. Bien que ça puisse paraître un peu limitant lorsqu'on vient d'un
monde impératif, on a vu que c'est en fait plutôt sympa. Dans un langage
impératif, vous n'avez aucune garantie qu'une fonction qui est censée calculer
des nombres ne va pas brûler votre maison, kidnapper votre chien et rayer votre
voiture avec une patate pendant qu'elle calcule ces nombres. Par exemple, quand
on a fait un arbre binaire de recherche, on n'a pas inséré un élément dans un
arbre en modifiant l'arbre à sa place. Notre fonction pour insérer dans un
arbre binaire retournait en fait un nouvel arbre, parce qu'elle ne peut pas
modifier l'ancien.

Bien qu'avoir des fonctions incapables de changer d'état soit bien puisque cela
nous aide à raisonner sur nos programmes, il y a un problème avec ça. Si une
fonction ne peut rien changer dans le monde, comment est-elle censée nous dire
ce qu'elle a calculé ? Pour nous dire ce qu'elle a calculé, elle doit pouvoir
changer l'état d'un matériel de sortie (généralement, l'état de notre écran),
qui va ensuite émettre des photons qui voyageront jusqu'à notre cerveau pour
changer l'état de notre esprit, mec.

Ne désespérez pas, tout n'est pas perdu. Il s'avère qu'Haskell a en fait un
système très malin pour gérer ces fonctions qui ont des effets de bord, qui
sépare proprement les parties de notre programme qui sont pures de celles qui
sont impures, font tout le sale boulot comme parler au clavier ou à l'écran.
Avec ces deux parties séparées, on peut toujours raisonner sur la partie pure
du programme, et bénéficier de toutes les choses que la pureté offre, comme la
paresse, la robustesse et la modularité, tout en communiquant efficacement avec
le monde extérieur.

<h2 id="hello-world">
Hello, world!
</h2>

<img src="img/helloworld.png" alt="HELLO!" class="left"/>

Jusqu'ici, nous avions toujours chargé nos fonctions dans GHCi pour les tester
et jouer avec elles. On a aussi exploré les fonctions de la bibliothèque
standard de cette façon. Mais à présent, après environ huit chapitres, on va
finalement écrire notre premier *vrai* programme Haskell ! Yay ! Et pour sûr,
on va se faire ce bon vieux `"hello, world"`.

<div class="hintbox">

**Hey !** Pour ce chapitre, je vais supposer que vous disposez d'un
environnement à la Unix pour apprendre Haskell. Si vous êtes sous Windows, je
suggère d'utiliser [Cygwin](http://www.cygwin.com/), un environnement à la
Linux pour Windows, autrement dit, juste ce qu'il vous faut.

</div>

Pour commencer, tapez ceci dans votre éditeur de texte favori&nbsp;:

> main = putStrLn "hello, world"

On vient juste de définir un nom `main`, qui consiste à appeler `putStrLn` avec
le paramètre `"hello, world"`. Ça semble plutôt banal, mais ça ne l'est pas,
comme on va le voir bientôt. Sauvegardez ce fichier sous `helloworld.hs`.

Et maintenant, on va faire quelque chose sans précédent. On va réellement
compiler notre programme ! Je suis tellement ému ! Ouvrez votre terminal et
naviguez jusqu'au répertoire où `helloworld.hs` est placé et faites&nbsp;:

> $ ghc --make helloworld
> [1 of 1] Compiling Main             ( helloworld.hs, helloworld.o )
> Linking helloworld ...

Ok ! Avec de la chance, vous avez quelque chose comme ça et vous pouvez à
présent lancer le programme en faisant `./helloworld`.

> $ ./helloworld
> hello, world

Et voilà, notre premier programme compilé qui affichait quelque chose dans le
terminal. Comme c'est extraordinaire(ment ennuyeux) !

Examinons ce qu'on vient d'écrire. D'abord, regardons le type de la fonction
`putStrLn`.

> ghci> :t putStrLn
> putStrLn :: String -> IO ()
> ghci> :t putStrLn "hello, world"
> putStrLn "hello, world" :: IO ()

On peut lire le type de `putStrLn` ainsi&nbsp;: `putStrLn` prend une chaîne de
caractères et retourne une **action I/O** qui a pour type de retour `()`
(c'est-à-dire le tuple vide, aussi connu comme *unit*). Une action I/O est
quelque chose qui, lorsqu'elle sera exécutée, va effectuer une action avec des
effets de bord (généralement, lire en entrée ou afficher à l'écran) et
contiendra une valeur de retour. Afficher quelque chose à l'écran n'a pas
vraiment de valeur de retour significative, alors une valeur factice `()` est
utilisée.

<div class="hintbox">

Le tuple vide est une valeur `()` qui a pour type `()`.

</div>

Donc, quand est-ce que cette action sera exécutée ? Eh bien, c'est ici que le
`main` entre en jeu. Une action I/O sera exécutée lorsqu'on lui donne le nom
`main` et qu'on lance le programme ainsi créé.

Que votre programme entier ne soit qu'une action I/O semble un peu limitant.
C'est pourquoi on peut utiliser la notation *do* pour coller ensemble plusieurs
actions I/O en une seule. Regardez l'exemple suivant&nbsp;:

> main = do
>     putStrLn "Hello, what's your name?"
>     name <- getLine
>     putStrLn ("Hey " ++ name ++ ", you rock!")

Ah, intéressant, une nouvelle syntaxe ! Et celle-ci se lit presque comme un
programme impératif. Si vous compilez cela et l'essayez, cela se comportera
certainement conformément à ce que vous attendez. Remarquez qu'on a dit *do*,
puis on a aligné une série d'étapes, comme en programmation impérative. Chacune
de ces étapes est une action I/O. En les mettant ensemble avec la syntaxe *do*,
on les a collées en une seule action I/O. L'action obtenue a pour type `IO ()`,
parce que c'est le type de la dernière action à l'intérieur du collage.

À cause de ça, `main` a toujours la signature de type `main :: IO something`,
où `something` est un type concret. Par convention, on ne spécifie généralement
pas la déclaration de type de `main`.

Une chose intéressante qu'on n'a pas rencontrée avant est à la troisième ligne,
qui dit `name <- getLine`. On dirait qu'elle lit une ligne depuis l'entrée et
la stocke dans une variable `name`. Est-ce le cas ? Examinons le type de
`getLine`.

> ghci> :t getLine
> getLine :: IO String

<img src="img/luggage.png" alt="bagage" class="left"/>

Aha, o-kay. `getLine` est une action I/O qui contient un résultat de type
`String`. Ça tombe sous le sens, parce qu'elle attendra que l'utilisateur tape
quelque chose dans son terminal, et ensuite, cette frappe sera représentée
comme une chaîne de caractères. Mais qu'est-ce qui se passe dans `name <-
getLine` alors ? Vous pouvez lire ceci ainsi&nbsp;: **effectue l'action I/O
`getLine` puis lie la valeur résultante au nom `name`**. `getLine` a pour type
`IO String`, donc `name` aura pour type `String`. Vous pouvez imaginer une
action I/O comme une boîte avec des petits pieds qui sortirait dans le monde
réel et irait faire quelque chose là-bas (comme des graffitis sur les murs) et
reviendrait peut-être avec une valeur. Une fois qu'elle a attrapé une valeur
pour vous, le seul moyen d'ouvrir la boîte pour en récupérer le contenu est
d'utiliser la construction `<-`. Et si l'on sort une valeur d'une action I/O,
on ne peut le faire qu'à l'intérieur d'une autre action I/O. C'est ainsi
qu'Haskell parvient à séparer proprement les parties pure et impure du code.
`getLine` est en un sens impure, parce que sa valeur de retour n'est pas
garantie d'être la même lorsqu'on l'exécute deux fois. C'est pourquoi elle est
en quelque sorte *tachée* par le constructeur de types `IO`, et on ne peut
récupérer cette donnée que dans du code I/O. Et puisque le code I/O est taché
aussi, tout calcul qui dépend d'une valeur tachée I/O renverra un résultat
taché.

Quand je dis *taché*, je ne veux pas dire taché de façon à ce que l'on ne
puisse plus jamais utiliser le résultat contenu dans l'action I/O dans un code
pur. Non, on dé-tache temporairement la donnée dans l'action I/O lorsqu'on la
lie à un nom. Quand on fait `name <- getLine`, `name` est une chaîne de
caractères normale, parce qu'elle représente ce qui est dans la boîte. On peut
avoir une fonction très compliquée qui, mettons, prend votre nom (une chaîne de
caractères normale) et un paramètre, et vous donne votre fortune et votre futur
basé sur votre nom. On peut faire cela&nbsp;:

> main = do
>     putStrLn "Hello, what's your name?"
>     name <- getLine
>     putStrLn $ "Read this carefully, because this is your future: " ++ tellFortune name

et `tellFortune` (ou n'importe quelle fonction à laquelle on passe `name`) n'a
pas besoin de savoir quoi que ce soit à propos d'I/O, c'est une simple fonction
`String -> String` !

Regardez ce bout de code. Est-il valide ?

> nameTag = "Hello, my name is " ++ getLine

Si vous avez répondu non, offrez-vous un cookie. Si vous avez dit oui, buvez un
verre de lave en fusion. Non, je blague ! La raison pour laquelle ça ne marche
pas, c'est parce que `++` requiert que ses deux paramètres soient des listes du
même type. Le premier paramètre a pour type `String` (ou `[Char]` si vous
voulez), alors que `getLine` a pour type `IO String`. On ne peut pas concaténer
une chaîne de caractères et une action I/O. On doit d'abord récupérer le
résultat de l'action I/O pour obtenir une valeur de type `String`, et le seul
moyen de faire ceci c'est de faire `name <- getLine` dans une autre action I/O.
Si l'on veut traiter des données impures, il faut le faire dans un
environnement impur. Ainsi, la trace de l'impureté se propage comme le fléau
des morts-vivants, et il est dans notre meilleur intérêt de restreindre les
parties I/O de notre code autant que faire se peut.

Chaque action I/O effectuée encapsule son résultat en son sein. C'est pourquoi
notre précédent programme aurait pu s'écrire ainsi&nbsp;:

> main = do
>     foo <- putStrLn "Hello, what's your name?"
>     name <- getLine
>     putStrLn ("Hey " ++ name ++ ", you rock!")

Cependant, `foo` aurait juste pour valeur `()`, donc écrire ça serait un peu
discutable. Remarquez qu'on n'a pas lié le dernier `putStrLn`. C'est parce que,
dans un bloc *do*, **la dernière action ne peut pas être liée à un nom**
contrairement aux précédentes. Nous verrons pourquoi c'est le cas un peu plus
tard quand nous nous aventurerons dans le monde des monades. Pour l'instant,
vous pouvez imaginer que le bloc *do* extrait automatiquement la valeur de la
dernière action et la lie à son propre résultat.

À part la dernière ligne, toute ligne d'un bloc *do* qui ne lie pas peut être
réécrite avec une liaison. Ainsi, `putStrLn "BLAH"` peut être réécrit comme `_
<- putStrLn "BLAH"`. Mais ça ne sert à rien, donc on enlève le `<-` pour les
actions I/O dont le résultat ne nous importe pas, comme `putStrLn something`.

Les débutants pensent parfois que faire

> name = getLine

va lire l'entrée et lier la valeur de cela à `name`. Eh bien non, tout ce que
cela fait, c'est de donner un autre nom à l'action I/O `getLine`, ici, `name`.
Rappelez-vous, pour obtenir une valeur d'une action I/O, vous devez le faire de
l'intérieur d'une autre action I/O et la liant à un nom via `<-`.

Les actions I/O ne seront exécutées que si elles ont pour nom `main` ou
lorsqu'elles sont dans une grosse action I/O composée par un bloc *do* en train
d'être exécutée. On peut utiliser les blocs *do* pour coller des actions I/O,
puis utiliser cette action I/O dans un autre bloc *do*, et ainsi de suite. De
toute façon, elles ne seront exécutées que si elles finissent par se retrouver
dans `main`.

Oh, j'oubliais, il y a un autre cas où une action I/O est exécutée. C'est
lorsque l'on tape cette action I/O dans GHCi et qu'on presse Entrée.

> ghci> putStrLn "HEEY"
> HEEY

Même lorsque l'on tape juste des nombres ou qu'on appelle une fonction dans
GHCi et qu'on tape Entrée, il va l'évaluer (autant que nécessaire) et appeler
`show` sur le résultat, puis afficher cette chaîne de caractères sur le
terminal en appelant implicitement `putStrLn`.

Vous vous souvenez des liaisons *let* ? Si ce n'est pas le cas,
rafraîchissez-vous l'esprit en lisant [cette
section](syntaxe-des-fonctions#let-it-be). Elles sont de la forme `let bindings
in expression`, où `bindings` sont les noms à donner aux expressions et
`expression` est l'expression évaluée qui peut voir ces liaisons. On a aussi
dit que dans les listes en compréhension, la partie *in* n'était pas
nécessaire. Eh bien, on peut aussi les utiliser dans les blocs *do* comme on le
faisait dans les listes en compréhension.  Regardez&nbsp;:

> import Data.Char
>
> main = do
>     putStrLn "What's your first name?"
>     firstName <- getLine
>     putStrLn "What's your last name?"
>     lastName <- getLine
>     let bigFirstName = map toUpper firstName
>         bigLastName = map toUpper lastName
>     putStrLn $ "hey " ++ bigFirstName ++ " " ++ bigLastName ++ ", how are you?"

Remarquez comme les actions I/O dans le bloc *do* sont alignées. Notez
également comme le *let* est aligné avec les actions I/O, et les noms du *let*
sont alignés les uns aux autres. C'est important, parce que l'indentation
importe en Haskell. Ici, on a fait `map toUpper firstName`, qui transforme
quelque chose comme `"John"` en une chaîne de caractères bien plus cool comme
`"JOHN"`. On a lié cette chaîne de caractères en capitales à un nom, puis utilisé
ce nom dans une chaîne de caractères qu'on a affichée sur le terminal plus
tard.

Vous vous demandez peut-être quand utiliser `<-` et quand utiliser des liaisons
*let* ? Eh bien, souvenez-vous, `<-` sert (pour l'instant) à effectuer une
action I/O et lier son résultat à un nom. `map toUpper firstName`, cependant,
n'est pas une action I/O. C'est une expression pure en Haskell.  Donc, utilisez
`<-` quand vous voulez lier le résultat d'une action I/O à un nom et utiliser
une liaison *let* pour lier une expression pure à un nom. Si on avait fait
quelque chose comme `let firstName = getLine`, on aurait juste donné à l'action
I/O `getLine` un nouveau nom, sans avoir exécuté cette action.

À présent, on va faire un programme qui lit continuellement une ligne et
l'affiche avec les mots renversés. Le programme s'arrêtera si on entre une
ligne vide. Voici le programme&nbsp;:

> main = do
>     line <- getLine
>     if null line
>         then return ()
>         else do
>             putStrLn $ reverseWords line
>             main
>
> reverseWords :: String -> String
> reverseWords = unwords . map reverse . words

Pour vous rendre compte de ce qu'il fait, essayez de l'exécuter avant qu'on
s'intéresse au code.

<div class="hintbox">

**Astuce**&nbsp;: Pour lancer un programme, vous pouvez soit le compiler puis
lancer l'exécutable produit en faisant `ghc --make helloworld` puis
`./helloworld`, ou bien vous pouvez utiliser la commande `runhaskell`
ainsi&nbsp;: `runhaskell helloworld.hs` et votre programme sera exécuté à la
volée.

</div>

Tout d'abord, regardons la fonction `reverseWords`. C'est une fonction normale
qui prend une chaîne de caractères comme `"hey there man"` et appelle `words`
pour produire une liste de mots comme `["hey", "there", "man"]`. Puis, on mappe
`reverse` sur la liste, résultant en `["yeh", "ereht", "nam"]`, puis on
regroupe cette liste en une chaîne en utilisant `unwords` et le résultat final
est `"yeh ereht nam"`. Voyez comme on a utilisé la composition de fonctions
ici. Sans cela, on aurait dû écrire `reverseWords st = unwords (map reverse
(words st))`.

Quid de `main` ? D'abord, on récupère une ligne du terminal avec `getLine` et
on nomme cette ligne `line`. Maintenant, on a une expression conditionnelle.
Souvenez-vous, en Haskell, tout *if* doit avoir un *else* parce que chaque
expression est une valeur. On a fait le *if* de sorte que lorsque la condition
est vraie (dans notre cas, la ligne est non vide), on exécute une action I/O,
et lorsqu'elle est vide, l'action I/O sous le *else* est exécutée à la place.
C'est pour cela que dans des blocs *do* I/O, les *if* doivent avoir la forme
`if condition then I/O action else I/O action`.

Regardons d'abord du côté de la clause *else*. Puisqu'on doit avoir une action
I/O après le *else*, on crée un bloc *do* pour coller des actions en une. Vous
pouvez aussi écrire cela&nbsp;:

> else (do
>     putStrLn $ reverseWords line
>     main)

Cela rend plus explicite le fait que le bloc *do* peut être vu comme une action
I/O, mais c'est plus moche. Peu importe, dans le bloc *do*, on appelle
`reverseWords` sur la ligne obtenue de `getLine`, puis on l'affiche au
terminal. Après cela, on exécute `main`. C'est un appel récursif, et c'est bon,
parce que `main` est bien une action I/O. En un sens, on est de retour au début
du programme.

Maintenant, que se passe-t-il lorsque `null line` est vrai ? Dans ce cas, ce
qui suit le *then* est exécuté. Si on regarde, on voit qu'il y a `then return
()`. Si vous avez utilisé des langages impératifs comme C, Java ou Python, vous
vous dites certainement que vous savez déjà ce que `return` fait, et il se peut
que vous ayez déjà sauté ce long paragraphe. Eh bien, voilà le détail qui
tue&nbsp;: **le `return` de Haskell n'a vraiment rien à voir avec le `return`
de la plupart des autres langages !** Il a le même nom, ce qui embrouille
beaucoup de monde, mais en réalité, il est bien différent. Dans les langages
impératifs, `return` termine généralement l'exécution de la méthode ou
sous-routine, en rapportant une valeur à son appelant. En Haskell (plus
spécifiquement, dans les action I/O), il crée une action I/O à partir d'une
valeur pure.  Si vous repensez à l'analogie de la boîte faite précédemment, il
prend une valeur et la met dans une boîte. L'action I/O résultante ne fait en
réalité rien, mais encapsule juste cette valeur comme son résultat. Ainsi, dans
un contexte d'I/O, `return "HAHA"` aura pour type `IO String`. Quel est le but
de transformer une valeur pure en une action I/O qui ne fait rien ? Pourquoi
salir notre programme d'`IO` plus que nécessaire ? Eh bien, il nous fallait une
action I/O à exécuter dans le cas où la ligne en entrée était vide.  C'est
pourquoi on a créé une fausse action I/O qui ne fait rien, en écrivant `return
()`.

Utiliser `return` ne cause pas la fin de l'exécution du bloc *do* I/O ou quoi
que ce soit du genre. Par exemple, ce programme va gentiment s'exécuter
jusqu'au bout de la dernière ligne&nbsp;:

> main = do
>     return ()
>     return "HAHAHA"
>     line <- getLine
>     return "BLAH BLAH BLAH"
>     return 4
>     putStrLn line

Tout ce que ces `return` font, c'est créer des actions I/O qui ne font rien de
spécial à part encapsuler un résultat, et les résultats sont ici jetés
puisqu'on ne les lie pas à des noms. On peut utiliser `return` en combinaison
avec `<-` pour lier des choses à des noms.

> main = do
>     a <- return "hell"
>     b <- return "yeah!"
>     putStrLn $ a ++ " " ++ b

Comme vous voyez, `return` est un peu l'opposé de `<-`. Alors que `return`
prend une valeur et l'enveloppe dans une boîte, `<-` prend une boîte,
l'exécute, et en extrait la valeur pour la lier à un nom. Faire cela est un peu
redondant, puisque l'on dispose des liaisons *let* dans les blocs *do*, donc on
préfère&nbsp;:

> main = do
>     let a = "hell"
>         b = "yeah"
>     putStrLn $ a ++ " " ++ b

Quand on fait des blocs *do* I/O, on utilise principalement `return` soit parce
que l'on a besoin de créer une action I/O qui ne fait rien, ou bien parce qu'on
ne veut pas que l'action créée par le bloc ait la valeur de la dernière action
qui la compose, auquel cas on place un `return` tout à la fin avec le résultat
qu'on veut obtenir de cette action composée.

<div class="hintbox">

Un bloc *do* peut aussi avoir une seule action I/O. Dans ce cas, c'est
équivalent à écrire seulement l'action. Certains vont préférer écrire `then do
return ()` parce que le *else* avait un *do*.

</div>

Avant de passer aux fichiers, regardons quelques fonctions utiles pour faire
des I/O.

`putStr` est un peu comme `putStrLn` puisqu'il prend une chaîne de caractères
en paramètre et retourne une action I/O qui affiche cette chaîne sur le
terminal, seulement `putStr` ne va pas à la ligne après avoir affiché la
chaîne, alors que `putStrLn` va à la ligne.

> main = do   putStr "Hey, "
>             putStr "I'm "
>             putStrLn "Andy!"

> $ runhaskell putstr_test.hs
> Hey, I'm Andy!

Sa signature de type est `putStr :: String -> IO ()`, donc le résultat
encapsulé est *unit*. Une valeur inutile, donc ça ne sert à rien de la lier.

`putChar` prend un caractère et retourne une action I/O qui l'affiche sur le
terminal.

> main = do   putChar 't'
>             putChar 'e'
>             putChar 'h'

> $ runhaskell putchar_test.hs
> teh

`putStr` est en fait défini récursivement à l'aide de `putChar`. Le cas de base
de `putStr` est la chaîne vide, donc si on affiche une chaîne vide, elle
retourne juste une action I/O qui ne fait rien à l'aide de `return ()`. Si la
chaîne n'est pas vide, elle affiche son premier caractère avec `putChar`, puis
affiche le reste de la chaîne avec `putStr`.

> putStr :: String -> IO ()
> putStr [] = return ()
> putStr (x:xs) = do
>     putChar x
>     putStr xs

Voyez comme on peut utiliser la récursivité dans les I/O, comme dans du code
pur. Comme pour un code pur, on définit un cas de base, et on réfléchit à ce
que le résultat doit être. C'est une action qui affiche le première caractère
puis affiche le reste de la chaîne.

`print` prend une valeur de n'importe quel type instance de `Show` (donc, qu'on
sait représenter sous forme de chaîne de caractères), et appelle `show` sur
cette valeur pour la transformer en chaîne, puis affiche cette chaîne sur le
terminal. En gros, c'est seulement `putStrLn . show`. Elle lance d'abord `show`
sur la valeur, puis nourrit `putStrLn` du résultat, qui va alors retourner une
action I/O qui affichera notre valeur.

> main = do   print True
>             print 2
>             print "haha"
>             print 3.2
>             print [3,4,3]

> $ runhaskell print_test.hs
> True
> 2
> "haha"
> 3.2
> [3,4,3]

Comme vous le voyez, cette fonction est très pratique. Vous vous souvenez qu'on
a dit que les actions I/O n'étaient exécutées que lorsqu'elles sont sous `main`
ou quand on essaie de les évaluer dans l'invite GHCi ? Quand on tape une valeur
(comme `3` ou `[1, 2, 3]`) et qu'on tape Entrée, GHCi utilise en fait `print`
sur cette valeur pour l'afficher dans notre terminal !

> ghci> 3
> 3
> ghci> print 3
> 3
> ghci> map (++"!") ["hey","ho","woo"]
> ["hey!","ho!","woo!"]
> ghci> print (map (++"!") ["hey","ho","woo"])
> ["hey!","ho!","woo!"]

Quand on veut afficher des chaînes de caractères, on utilise généralement
`putStrLn` parce qu'on ne veut pas des guillemets autour d'elles, mais pour
afficher toutes les autres valeurs, `print` est généralement utilisé.

`getChar` est une action I/O qui lit un caractère de l'entrée. Ainsi, sa
signature de type est `getChar :: IO Char`, parce que le résultat contenu dans
l'action I/O a pour type `Char`. Notez que les caractères sont mis en tampon,
ainsi la lecture des caractères n'aura pas lieu tant que l'utilisateur ne tape
pas Entrée.

> main = do
>     c <- getChar
>     if c /= ' '
>         then do
>             putChar c
>             main
>         else return ()

Ce programme semble lire un caractère et vérifier si c'est une espace. Si c'est
le cas, il s'arrête, sinon il affiche le caractère et recommence. C'est un peu
ce qu'il fait, mais pas forcément comme on s'y attend. Regardez&nbsp;:

> $ runhaskell getchar_test.hs
> hello sir
> hello

La seconde ligne est l'entrée. On tape `hello sir` et on appuie sur Entrée. À
cause de la mise en tampon, l'exécution du programme ne démarre que lorsqu'on
tape Entrée, et pas à chaque caractère tapé. Mais une fois qu'on presse Entrée,
il agit sur ce qu'on vient de taper. Essayez de jouer avec ce programme pour
vous rendre compte !

La fonction `when` est dans `Control.Monad` (pour l'utiliser, faites `import
Control.Monad`). Elle est intéressante parce que, dans un bloc *do*, on dirait
qu'elle contrôle le flot du programme, alors qu'en fait c'est une fonction tout
à fait normale. Elle prend une valeur booléenne et une action I/O. Si la valeur
booléenne est `True`, elle retourne l'action I/O qu'on lui a passée. Si c'est
`False`, elle retourne `return ()`, donc une action I/O qui ne fait rien. Voici
comment on pourrait réécrire le code précédent dans lequel on présentait
`getChar`, en utilisant `when`&nbsp;:

> import Control.Monad
>
> main = do
>     c <- getChar
>     when (c /= ' ') $ do
>         putChar c
>         main

Comme vous voyez, c'est utile pour encapsuler le motif `if something then do
some I/O action else return ()`.

`sequence` prend une liste d'actions I/O et retourne une action I/O qui
exécutera ces actions l'une après l'autre. Le résultat contenu dans cette
action I/O sera la liste de tous les résultats de toutes les actions I/O
exécutées. Sa signature de type est `sequence :: [IO a] -> IO [a]`. Faire ceci
:

> main = do
>     a <- getLine
>     b <- getLine
>     c <- getLine
>     print [a,b,c]

est équivalent à faire :

> main = do
>     rs <- sequence [getLine, getLine, getLine]
>     print rs

Donc `sequence [getLine, getLine, getLine]` crée une action I/O qui va exécuter
`getLine` trois fois. Si on lie cette action à un nom, le résultat sera une
liste de tous les résultats, dans notre cas, une liste de trois choses que
l'utilisateur a tapées dans l'invite.

Un motif courant avec `sequence` consiste à mapper des fonctions comme `print`
ou `putStrLn` sur des listes. Faire `map print [1, 2, 3, 4]` ne créera pas une
action I/O. Cela va créer une liste d'actions I/O, car c'est équivalent à
`[print 1, print 2, print 3, print 4]`. Si on veut transformer une liste
d'actions I/O en une action I/O, il faut la séquencer.

> ghci> sequence (map print [1,2,3,4,5])
> 1
> 2
> 3
> 4
> 5
> [(),(),(),(),()]

C'est quoi ce `[(), (), (), (), ()]` à la fin ? Eh bien, quand on évalue une
action I/O dans GHCi, elle est exécutée et le résultat est affiché, à moins que
ce ne soit `()`, auquel cas il n'est pas affiché. C'est pourquoi évaluer
`putStrLn "hehe"` dans GHCi affiche seulement `hehe` (parce que le résultat
contenu dans cette action est `()`). Mais quand on fait `getLine` dans GHCi, le
résultat de cette action est affiché dans GHCi, parce que `getLine` a pour type
`IO String`.

Puisque mapper une fonction qui retourne une action I/O sur une liste puis
séquencer cette liste est tellement commun, les fonctions utilitaires `mapM` et
`mapM_` ont été introduites. `mapM` prend une fonction et une liste, mappe la
fonction sur la liste et séquence le tout. `mapM_` fait pareil, mais jette le
résultat final. On utilise généralement `mapM_` lorsqu'on se fiche du résultat
de nos actions séquencées.

> ghci> mapM print [1,2,3]
> 1
> 2
> 3
> [(),(),()]
> ghci> mapM_ print [1,2,3]
> 1
> 2
> 3

`forever` prend une action I/O et retourne une action I/O qui répète la
première indéfiniment. Elle est dans `Control.Monad`. Ce programme va demander
indéfiniment à l'utilisateur une entrée, et va la recracher en
LETTRES CAPITALES&nbsp;:

> import Control.Monad
> import Data.Char
>
> main = forever $ do
>     putStr "Give me some input: "
>     l <- getLine
>     putStrLn $ map toUpper l

`forM` (dans `Control.Monad`) est comme `mapM`, mais avec les paramètres dans
l'ordre inverse. Le premier paramètre est la liste, et le second la fonction à
mapper sur cette liste, qui sera finalement séquencée. Pourquoi est-ce utile ?
Eh bien, en étant un peu créatif sur l'utilisation des lambdas et de la
notation *do*, on peut faire des choses comme&nbsp;:

> import Control.Monad
>
> main = do
>     colors <- forM [1,2,3,4] (\a -> do
>         putStrLn $ "Which color do you associate with the number " ++ show a ++ "?"
>         color <- getLine
>         return color)
>     putStrLn "The colors that you associate with 1, 2, 3 and 4 are: "
>     mapM putStrLn colors

Le `(\a -> do ...)` est une fonction qui prend un nombre et retourne une action
I/O. On l'a mise entre parenthèses, sinon le lambda croit que les deux
dernières actions I/O sur les deux dernières lignes lui appartiennent
également. Remarquez qu'on fait `return color` dans le bloc *do*. On fait cela
de manière à ce que l'action I/O définie par ce bloc *do* contienne pour
résultat notre couleur. En fait on n'avait pas besoin de faire ça ici, puisque
`getLine` contient déjà ce résultat. Faire `color <- getLine` suivi de `return
color` consiste seulement à sortir le résultat de `getLine` et à le remettre
dans la boîte juste après, donc il suffit de faire juste `getLine`. Le `forM`
(appelé avec ses deux paramètres) produit une action I/O dont on lie le
résultat à `colors`. `colors` est une liste tout ce qu'il y a de plus normale,
qui contient des chaînes de caractères. À la fin, on affiche toutes ces
couleurs en faisant `mapM putStrLn colors`.

Vous pouvez imaginer `forM` comme signifiant&nbsp;: crée une action I/O pour
tous les éléments de cette liste. Ce que l'action I/O fait peut dépendre de la
valeur de l'élément de la liste à partir duquelle elle a été créée. Finalement,
exécute toutes ces actions et lie leur résultat à quelque chose. Notez qu'on
n'est pas forcé de le lier, on pourrait juste le jeter.

> $ runhaskell form_test.hs
> Which color do you associate with the number 1?
> white
> Which color do you associate with the number 2?
> blue
> Which color do you associate with the number 3?
> red
> Which color do you associate with the number 4?
> orange
> The colors that you associate with 1, 2, 3 and 4 are:
> white
> blue
> red
> orange

On aurait pu le faire sans `forM`, mais c'est plus lisible avec. Généralement,
on utilise `forM` pour mapper et séquencer des actions que l'on définit au vol
avec la notation *do*. Dans la même veine, on aurait pu remplacer la dernière
ligne par `forM colors putStrLn`.

Dans cette section, on a vu les bases de l'entrée-sortie. On a aussi vu ce que
les actions I/O sont, comment elles nous permettent de faire des
entrées-sorties, et quand elles sont réellement exécutées. Pour en remettre une
couche, les actions I/O sont des valeurs presque comme les autres en Haskell.
On peut les passer en paramètre à des fonctions, et des fonctions peuvent en
retourner comme résultat. Ce qui est spécial à leur propos, c'est que si elles
se retrouvent sous la fonction `main` (ou dans GHCi), elles sont exécutées. Et
c'est alors qu'elles se retrouvent à écrire des choses sur votre écran ou à
jouer Yakety Sax dans vos haut-parleurs. Chaque action I/O peut encapsuler un
résultat qui vous dira ce qu'elle a trouvé dans le monde réel.

Ne pensez pas que `putStrLn` est une fonction qui prend une chaîne de
caractères et l'affiche à l'écran. Pensez-y comme une fonction qui prend une
chaîne de caractères et retourne une action I/O. Cette action I/O affichera,
lorsqu'elle sera exécutée, de magnifiques poèmes dans votre terminal.

<h2 id="fichiers-et-flots">
Fichiers et flots
</h2>

<img src="img/streams.png" alt="flots" class="right"/>

`getChar` est une action I/O qui lit un caractère du terminal. `getLine` est
une action I/O qui lit une ligne du terminal. Ces deux sont plutôt simples, et
la plupart des langages de programmation ont des fonctions ou des instructions
semblables à ces actions I/O. Mais à présent, rencontrons `getContents`.
`getContents` est une action I/O qui lit toute l'entrée standard jusqu'à
rencontrer un caractère de fin de fichier. Son type est `getContents :: IO
String`. Ce qui est cool avec `getContents`, c'est qu'elle effectue une entrée
paresseuse. Quand on fait `foo <- getContents`, elle ne va pas lire toute
l'entrée d'un coup, la stocker en mémoire, puis la lier à `foo`. Non, elle est
paresseuse ! Elle dira&nbsp;: "_Ouais ouais, je lirai l'entrée du terminal plus
tard, quand tu en auras besoin !_".

`getContents` est très utile quand on veut connecter la sortie d'un programme à
l'entrée de notre programme. Si vous ne savez pas comment cette connexion (à
base de *tubes*) fonctionne dans les systèmes type Unix, voici un petit aperçu.
Créons un fichier texte qui contient ce haïku&nbsp;:

> I'm a lil' teapot
> What's with that airplane food, huh?
> It's so small, tasteless

Ouais, le haïku est pourri, mais bon ? Si quelqu'un connaît un tutoriel de
haïkus, je suis preneur.

Bien, souvenez-vous de ce programme qu'on a écrit en introduisant la fonction
`forever`. Il demandait à l'utilisateur une ligne, et la lui retournait en
LETTRES CAPITALES, puis recommençait, indéfiniment. Pour vous éviter de remonter tout
là-haut, je vous la remets ici&nbsp;:

> import Control.Monad
> import Data.Char
>
> main = forever $ do
>     putStr "Give me some input: "
>     l <- getLine
>     putStrLn $ map toUpper l

Sauvegardons ce programme comme `capslocker.hs` ou ce que vous voulez, et
compilons-le. À présent, on va utiliser un tube Unix pour donner notre fichier
texte à manger à notre petit programme. On va utiliser le programme GNU *cat*,
qui affiche le fichier donné en argument. Regardez-moi ça, booyaka !

> $ ghc --make capslocker
> [1 of 1] Compiling Main             ( capslocker.hs, capslocker.o )
> Linking capslocker ...
> $ cat haiku.txt
> I'm a lil' teapot
> What's with that airplane food, huh?
> It's so small, tasteless
> $ cat haiku.txt | ./capslocker
> I'M A LIL' TEAPOT
> WHAT'S WITH THAT AIRPLANE FOOD, HUH?
> IT'S SO SMALL, TASTELESS
> capslocker <stdin>: hGetLine: end of file

Comme vous voyez, connecter la sortie d'un programme (dans notre cas c'était
*cat*) à l'entrée d'un autre (ici *capslocker*) est fait à l'aide du caractère
`|`. Ce qu'on a fait ici est à peu près équivalent à lancer *capslocker*, puis
taper notre haïku dans le terminal, avant d'envoyer le caractère de fin de
fichier (généralement en tapant Ctrl-D). C'est comme lancer *cat haiku.txt* et
dire&nbsp;: "Attends, n'affiche pas ça dans le terminal, va le dire à
*capslocker* plutôt !".

Donc ce qu'on fait principalement avec cette utilisation de `forever` c'est
prendre l'entrée et la transformer en une sortie. C'est pourquoi on peut
utiliser `getContents` pour rendre ce programme encore plus court et
joli&nbsp;:

> import Data.Char
>
> main = do
>     contents <- getContents
>     putStr (map toUpper contents)

On lance l'action I/O `getContents` et on nomme la chaîne produite `contents`.
Puis on mappe `toUpper` sur cette chaîne, et on l'affiche sur le terminal.
Gardez en tête que puisque les chaînes de caractères sont simplement des
listes, qui sont paresseuses, et que `getContents` est aussi paresseuse en
entrée-sortie, cela ne va pas essayer de lire tout le contenu et de le stocker
en mémoire avant d'afficher la version en lettres capitales. Plutôt, cela va afficher
la version en capitales au fur et à mesure de la lecture, parce que cela ne
lira une ligne de l'entrée que lorsque ce sera nécessaire.

> $ cat haiku.txt | ./capslocker
> I'M A LIL' TEAPOT
> WHAT'S WITH THAT AIRPLANE FOOD, HUH?
> IT'S SO SMALL, TASTELESS

Cool, ça marche. Et si l'on essaie de lancer *capslocker* et de taper les
lignes nous-même ?

> $ ./capslocker
> hey ho
> HEY HO
> lets go
> LETS GO

On a quitté le programme en tapant Ctrl-D. Plutôt joli ! Comme vous voyez, cela
affiche nos caractères en capitales ligne après ligne. Quand le résultat de
`getContents` est lié à `contents`, ce n'est pas représenté en mémoire comme
une vraie chaîne de caractères, mais plutôt comme une promesse de produire
cette chaîne de caractères en temps voulu. Quand on mappe `toUpper` sur
`contents`, c'est aussi une promesse de mapper la fonction sur le contenu une
fois qu'il sera disponible. Et finalement, quand `putStr` est exécuté, il dit à
la promesse précédente&nbsp;: "_Hé, j'ai besoin des lignes en lettres capitales !_".
Celle-ci n'a pas encore les lignes, alors elle demande à `contents`&nbsp;:
"_Hé, pourquoi tu n'irais pas chercher ces lignes dans le terminal à présent
?_".  C'est à ce moment que `getContents` va vraiment lire le terminal et
donner une ligne au code qui a demandé d'avoir quelque chose de tangible. Ce
code mappe alors `toUpper` sur la ligne et la donne à `putStr`, qui l'affiche.
Puis `putStr` dit&nbsp;: "_Hé, j'ai besoin de la ligne suivante, allez !_" et
tout ceci se répète jusqu'à ce qu'il n'y ait plus d'entrée, comme l'indique le
caractère de fin de fichier.

Faisons un programme qui prend une entrée et affiche seulement les lignes qui
font moins de 10 caractères de long. Observez&nbsp;:

> main = do
>     contents <- getContents
>     putStr (shortLinesOnly contents)
>
> shortLinesOnly :: String -> String
> shortLinesOnly input =
>     let allLines = lines input
>         shortLines = filter (\line -> length line < 10) allLines
>         result = unlines shortLines
>     in  result

On a fait la partie I/O du programme la plus courte possible. Puisque notre
programme est censé lire une entrée, et afficher quelque chose en fonction de
l'entrée, on peut l'implémenter en lisant le contenu d'entrée, puis en
exécutant une fonction pure sur ce contenu, et en affichant le résultat que la
fonction a renvoyé.

La fonction `shortLinesOnly` fonctionne ainsi&nbsp;: elle prend une chaîne de
caractères comme `"short\nlooooooooooooooong\nshort again"`. Cette chaîne a
trois lignes, dont deux courtes et une au milieu plus longue. La fonction lance
`lines` sur cette chaîne, ce qui la convertit en `["short",
"looooooooooooooong", "short again"]`, qu'on lie au nom `allLines`. Cette liste
de chaînes est ensuite filtrée pour ne garder que les lignes de moins de 10
caractères, produisant `["short", "short again"]`. Et finalement, `unlines`
joint cette liste en une seule chaîne, donnant `"short\nshort again"`. Testons
cela.

> i'm short
> so am i
> i am a loooooooooong line!!!
> yeah i'm long so what hahahaha!!!!!!
> short line
> loooooooooooooooooooooooooooong
> short

> $ ghc --make shortlinesonly
> [1 of 1] Compiling Main             ( shortlinesonly.hs, shortlinesonly.o )
> Linking shortlinesonly ...
> $ cat shortlines.txt | ./shortlinesonly
> i'm short
> so am i
> short

On connecte le contenu de *shortlines.txt* à l'entrée de *shotlinesonly* et en
sortie, on obtient les lignes courtes.

Ce motif qui récupère une chaîne en entrée, la transforme avec une fonction,
puis écrit le résultat est tellement commun qu'il existe une fonction qui rend
cela encore plus simple, appelée `interact`. `interact` prend une fonction de
type `String -> String` en paramètre et retourne une action I/O qui va lire une
entrée, lancer cette fonction dessus, et afficher le résultat. Modifions notre
programme en conséquence&nbsp;:

> main = interact shortLinesOnly
>
> shortLinesOnly :: String -> String
> shortLinesOnly input =
>     let allLines = lines input
>         shortLines = filter (\line -> length line < 10) allLines
>         result = unlines shortLines
>     in  result

Juste pour montrer que ceci peut être fait en beaucoup moins de code (bien que
ce soit moins lisible) et pour démontrer notre maîtrise de la composition de
fonctions, on va retravailler cela.

> main = interact $ unlines . filter ((<10) . length) . lines

Wow, on a réduit cela à juste une ligne, c'est plutôt cool !

`interact` peut être utilisé pour faire des programmes à qui l'on connecte un
contenu en entrée et qui affichent un résultat en conséquence, ou bien pour
faire des programmes qui semblent attendre une entrée de l'utilisateur, et
rendent un résultat basé sur la ligne entrée, puis prend une autre ligne, etc.
Il n'y a en fait pas de réelle distinction entre les deux, ça dépend juste de
la façon dont l'utilisateur veut utiliser le programme.

Faisons un programme qui lit continuellement une ligne et nous dit si la ligne
était un palindrome ou pas. On pourrait utiliser `getLine` pour lire une ligne,
dire à l'utilisateur si c'est un palindrome, puis lancer `main` à nouveau. Mais
il est plus simple d'utiliser `interact`. Quand vous utilisez `interact`,
pensez à tout ce que vous avez besoin de faire pour transformer une entrée en
la sortie désirée. Dans notre cas, on doit remplacer chaque ligne de l'entrée
par soit `"palindrome"`, soit `"not a palindrome"`. Donc on doit écrire une
fonction qui transforme quelque chose comme `"elephant\nABCBA\nwhatever"` en
`"not a palindrome\npalindrome\nnot a palindrome"`. Faisons ça !

> respondPalindromes contents = unlines (map (\xs -> if isPalindrome xs then "palindrome" else "not a palindrome") (lines contents))
>     where   isPalindrome xs = xs == reverse xs

Écrivons ça sans point.

> respondPalindromes = unlines . map (\xs -> if isPalindrome xs then "palindrome" else "not a palindrome") . lines
>     where   isPalindrome xs = xs == reverse xs

Plutôt direct. D'abord, on change quelque chose comme
`"elephant\nABCBA\nwhatever"` en `["elephant", "ABCBA", "whatever"]`, puis on
mappe la lambda sur ça, donnant `["not a palindrome", "palindrome", "not a
palindrome"]` et enfin `unlines` joint cette liste en une seule chaîne de
caractères. À présent, on peut faire&nbsp;:

> main = interact respondPalindromes

Testons ça&nbsp;:

> $ runhaskell palindromes.hs
> hehe
> not a palindrome
> ABCBA
> palindrome
> cookie
> not a palindrome

Bien qu'on ait fait un programme qui transforme une grosse chaîne de caractères
en une autre, ça se passe comme si on avait fait un programme qui faisait cela
ligne par ligne. C'est parce qu'Haskell est paresseux et veut afficher la
première ligne de la chaîne de caractères en sortie, mais ne peux pas parce
qu'il ne l'a pas encore. Dès qu'on lui donne une ligne en entrée, il va
l'afficher en sortie. On termine le programme en envoyant un caractère de fin
de fichier.

On peut aussi utiliser ce programme en connectant simplement un fichier en
entrée. Disons qu'on ait ce fichier&nbsp;:

> dogaroo
> radar
> rotor
> madam

et qu'on le sauvegarde comme `words.txt`. Voici ce qu'on obtient en le
connectant en entrée de notre programme&nbsp;:

> $ cat words.txt | runhaskell palindromes.hs
> not a palindrome
> palindrome
> palindrome
> palindrome

Encore une fois, on obtient la même sortie que si l'on avait tapé les mots dans
le programme nous-même. Seulement, on ne voit pas l'entrée affichée puisqu'elle
est venue du programme et qu'on ne l'a pas tapée ici.

Vous voyez probablement comment les entrées-sorties paresseuses fonctionnent à
présent, et comment on peut en tirer parti. Vous pouvez penser simplement à ce
que doit être la sortie en fonction de l'entrée, et écrire une fonction qui
effectue cette transformation. En entrée-sortie paresseuse, rien n'est consommé
en entrée tant que ce n'est pas absolument nécessaire, par exemple parce que
l'on souhaite afficher un résultat qui dépend de cette entrée.

Jusqu'ici, nous avons travaillé avec les entrées-sorties en affichant des
choses dans le terminal, et en lisant des choses depuis ce dernier. Mais
pourquoi pas lire et écrire des fichiers ? En quelque sorte on a déjà fait ça.
Une manière de penser au terminal est de se dire que c'est un fichier (un peu
spécial). On peut appeler le fichier de ce qu'on tape dans le terminal `stdin`,
et le fichier qui s'affiche dans notre terminal `stdout`, pour *entrée
standard* et *sortie standard*, respectivement. En gardant cela à l'esprit, on
va voir qu'écrire ou lire dans un fichier est très similaire à écrire ou lire
dans l'entrée ou la sortie standard.

On va commencer avec un programme très simple qui ouvre un fichier nommé
*girlfriend.txt*, qui contient un vers du tube d'Avril Lavigne numéro 1
*Girlfriend*, et juste afficher cela dans le terminal. Voici
*girlfriend.txt*&nbsp;:

> Hey! Hey! You! You!
> I don't like your girlfriend!
> No way! No way!
> I think you need a new one!

Et voici notre programme&nbsp;:

> import System.IO
>
> main = do
>     handle <- openFile "girlfriend.txt" ReadMode
>     contents <- hGetContents handle
>     putStr contents
>     hClose handle

En le lançant, on obtient le résultat attendu&nbsp;:

> $ runhaskell girlfriend.hs
> Hey! Hey! You! You!
> I don't like your girlfriend!
> No way! No way!
> I think you need a new one!

Regardons cela ligne par ligne. La première ligne contient juste quatre
exclamations, pour attirer notre attention. Dans la deuxième ligne, Avril nous
indique qu'elle n'apprécie pas notre partenaire romantique actuelle. La
troisième ligne sert à mettre en emphase cette désapprobation, alors que la
quatrième ligne suggère que nous devrions chercher une nouvelle petite amie.

Hum, regardons plutôt le programme ligne par ligne ! Notre programme consiste
en plusieurs actions I/O combinées ensemble par un bloc *do*. Dans la première
ligne du bloc *do*, on remarque une fonction nouvelle nommée *openFile*. Voici
sa signature de type&nbsp;: `openFile :: FilePath -> IOMode -> IO Handle`. Si
vous lisez ceci tout haut, cela donne&nbsp;: `openFile` prend un chemin vers un
fichier et un `IOMode` et retourne une action I/O qui va ouvrir le fichier et
encapsule pour résultat la poignée vers le fichier associé.

`FilePath` est juste un [synonyme du
type](creer-nos-propres-types-et-classes-de-types#synonymes-de-types) `String`,
simplement défini comme&nbsp;:

> type FilePath = String

`IOMode` est défini ainsi&nbsp;:

> data IOMode = ReadMode | WriteMode | AppendMode | ReadWriteMode

<img src="img/file.png" alt="UNE LIME DANS UN GÂTEAU !!!" class="left"/>

Tout comme notre type qui représente sept valeurs pour les jours de la semaine,
ce type est une énumération qui représente ce qu'on veut faire avec le fichier
ouvert. Très simple. Notez bien que le type est `IOMode` et non pas `IO Mode`.
Ce dernier serait le type d'une action I/O qui contient une valeur d'un type
`Mode`, alors qu'`IOMode` est juste une simple énumération.

Finalement, la fonction retourne une action I/O qui ouvre le fichier spécifié
dans le mode indiqué. Si l'on lie cette action à un nom, on obtient un
`Handle`. Une valeur de type `Handle` représente notre fichier ouvert. On
utilise cette poignée pour savoir de quel fichier on parle. Il serait stupide
d'ouvrir un fichier mais ne pas lier cette poignée à un nom, puisqu'on ne
pourrait alors pas savoir quel fichier on a ouvert. Dans notre cas, on lie la
poignée au nom `handle`.

À la prochaine ligne, on voit une fonction nommée `hGetContents`. Elle prend un
`Handle`, afin de savoir de quel fichier on veut récupérer le contenu, et
retourne une `IO String` - une action I/O qui contient en résultat le contenu
du fichier. Cette fonction est proche de `getContents`. La seule différence,
c'est que `getContents` lit automatiquement depuis l'entrée standard (votre
terminal), alors que `hGetContents` prend une poignée pour savoir quel fichier
elle doit lire. Pour le reste, elles font la même chose. Et tout comme
`getContents`, `hGetContents` ne va pas lire tout le fichier et le stocker en
mémoire, mais lire ce qui sera nécessaire pour progresser. C'est très cool
parce qu'on peut traiter `contents` comme le contenu de tout le fichier, alors
qu'il n'est pas réellement chargé en entier dans la mémoire. Donc, même pour un
énorme fichier, faire `hGetContents` ne va pas étouffer notre mémoire, parce
que le fichier est lu seulement quand c'est nécessaire.

Notez bien la différence entre la poignée, utilisée pour identifier le fichier,
et le contenu de ce fichier, liés respectivement dans ce programme aux noms
`handle` et `contents`. La poignée est juste quelque chose qui indique quel est
notre fichier. Si vous imaginez que votre système de fichiers est un énorme
livre, dont les fichiers sont des chapitres, la poignée est une sorte de
marque-page qui montre quel chapitre vous souhaitez lire (ou écrire), alors que
le contenu est celui du chapitre.

Avec `putStr contents`, on affiche seulement le contenu sur la sortie standard,
puis on fait `hClose`, qui prend une poignée et retourne une action I/O qui
ferme le fichier. Il faut fermer le fichier vous-même après l'avoir ouvert avec
`openFile` !

Un autre moyen de faire tout ça consiste à utiliser la fonction `withFile`, qui
a pour type `withFile :: FilePath -> IOMode -> (Handle -> IO a) -> IO a`. Elle
prend un chemin vers un fichier, un `IOMode` et une fonction qui prend une
poignée et retourne une action I/O. Elle retourne alors une action I/O qui
ouvre le fichier, applique notre fonction, puis ferme le fichier. Le résultat
retourné par cette action I/O est le même que le résultat retourné par la
fonction qu'on lui fournit. Ça peut vous sembler compliqué, mais c'est en fait
très simple, surtout avec des lambdas, voici le précédent exemple réécrit avec
`withFile`&nbsp;:

> import System.IO
>
> main = do
>     withFile "girlfriend.txt" ReadMode (\handle -> do
>         contents <- hGetContents handle
>         putStr contents)

Comme vous le voyez, c'est très similaire au code précédent. `(\handle -> ...)`
est une fonction qui prend une poignée et retourne une action I/O, et on le
fait généralement comme ça avec une lambda. La raison pour laquelle `withFile`
doit prendre une fonction qui retourne une action I/O, plutôt que de prendre
directement une action I/O, est que l'action I/O ne saurait pas sur quel
fichier elle doit agir autrement. Ainsi, `withFile` ouvre le fichier et passe
la poignée à la fonction qu'on lui a donnée. Elle récupère ainsi une action
I/O, et crée à son tour une action I/O qui est comme la précédente mais ferme
le fichier à la fin. Voici comment coder notre propre fonction
`withFile`&nbsp;:

> withFile' :: FilePath -> IOMode -> (Handle -> IO a) -> IO a
> withFile' path mode f = do
>     handle <- openFile path mode
>     result <- f handle
>     hClose handle
>     return result

<img src="img/edd.png" alt="tartine beurrée" class="right"/>

On sait que le résultat sera une action I/O, donc on peut commencer par écrire
un *do*. D'abord, on ouvre le fichier pour récupérer une poignée. Puis, on
applique notre fonction sur cette poignée pour obtenir une action I/O qui fait
son travail sur ce fichier. On lie le résultat de cette action à `result`, on
ferme la poignée, et on fait `return result`. En retournant le résultat
encapsulé dans l'action I/O obtenue par `f`, notre action I/O composée
encapsule le même résultat que celui de `f handle`. Ainsi, si `f handle`
retourne une action I/O qui lit un nombre de lignes de l'entrée standard, les
écrit dans un fichier, et encapsule pour résultat le nombre de lignes qu'elle a
lues, alors en l'utilisant avec `withFile'`, l'action I/O résultante aurait
également pour résultat le nombre de lignes lues.

Tout comme on a `hGetContents` qui fonctionne comme `getContents` mais pour un
fichier, il y a aussi `hGetLine`, `hPutStr`, `hPutStrLn`, `hGetChar`, etc.
Elles fonctionnent toutes comme leur équivalent sans h, mais prennent une
poignée en paramètre et opèrent sur le fichier correspondant plutôt que
l'entrée ou la sortie standard. Par exemple&nbsp;: `putStrLn` est une fonction
qui prend une chaîne de caractères et retourne une action I/O qui affiche cette
chaîne dans le terminal avec un retour à la ligne à la fin. `hPutStrLn` prend
une poignée et une chaîne et retourne une action I/O qui écrit cette chaîne
dans le fichier associé à la poignée, suivie d'un retour à la ligne. Dans la
même veine, `hGetLine` prend une poignée et retourne une action I/O qui lit une
ligne de ce fichier.

Charger des fichiers et traiter leur contenu comme des chaînes de caractères
est tellement commun qu'on a ces trois fonctions qui facilitent le
travail&nbsp;:

`readFile` a pour signature `readFile :: FilePath -> IO String`. Souvenez-vous
que `FilePath` est juste un nom plus joli pour `String`. `readFile` prend un
chemin vers un fichier et retourne une action I/O qui lit ce fichier
(paresseusement bien sûr) et lie son contenu à une chaîne de caractères. C'est
généralement plus pratique que de faire `openFile`, de lier le retour à une
poignée, puis de faire `hGetContents`. Ainsi, le précédent exemple se
réécrit&nbsp;:

> import System.IO
>
> main = do
>     contents <- readFile "girlfriend.txt"
>     putStr contents

Puisqu'on ne récupère pas de poignée, on ne peut pas fermer le fichier
manuellement, donc Haskell le fait tout seul quand on utilise `readFile`.

`writeFile` a pour type `writeFile :: FilePath -> String -> IO ()`. Elle prend
un chemin vers un fichier et une chaîne de caractères à écrire dans ce fichier
et retourne une action I/O qui effectuera l'écriture. Si le fichier existe
déjà, il sera écrasé complètement avant que l'écriture ne commence. Voici
comment transformer *girlfriend.txt* en une version en LETTRES CAPITALES et écrire
cette version dans *girlfriendcaps.txt*.

> import System.IO
> import Data.Char
>
> main = do
>     contents <- readFile "girlfriend.txt"
>     writeFile "girlfriendcaps.txt" (map toUpper contents)

> $ runhaskell girlfriendtocaps.hs
> $ cat girlfriendcaps.txt
> HEY! HEY! YOU! YOU!
> I DON'T LIKE YOUR GIRLFRIEND!
> NO WAY! NO WAY!
> I THINK YOU NEED A NEW ONE!

`appendFile` a la même signature de type que `writeFile`, mais elle ne tronque
pas le fichier s'il existe déjà, à la place elle écrit à la suite du contenu du
fichier existant.

Mettons qu'on ait un fichier *todo.txt* qui a une tâche par ligne de chose
qu'on doit penser à faire. Faisons un programme qui prend une ligne de l'entrée
standard et l'ajoute à notre liste de tâches.

> import System.IO
>
> main = do
>     todoItem <- getLine
>     appendFile "todo.txt" (todoItem ++ "\n")

> $ runhaskell appendtodo.hs
> Iron the dishes
> $ runhaskell appendtodo.hs
> Dust the dog
> $ runhaskell appendtodo.hs
> Take salad out of the oven
> $ cat todo.txt
> Iron the dishes
> Dust the dog
> Take salad out of the oven

On a dû ajouter le `"\n"` à la fin de chaque ligne, parce que `getLine` ne met
pas de caractère pour aller à la ligne à la fin.

Ooh, encore une chose. On a dit que `contents <- hGetContents handle` ne lisait
pas tout le fichier d'un coup pour le stocker en mémoire. C'est une
entrée-sortie paresseuse, donc faire&nbsp;:

> main = do
>     withFile "something.txt" ReadMode (\handle -> do
>         contents <- hGetContents handle
>         putStr contents)

c'est comme connecter un tube depuis le fichier vers la sortie. Comme on peut
penser aux listes comme à des flots, on peut aussi penser les fichiers comme
des flots. Ceci va lire une ligne à la fois et l'afficher sur le terminal au
passage. Vous vous demandez peut-être quelle est la taille de ce tube alors ?
Combien de fois va-t-on accéder au disque ? Eh bien, pour les fichiers textes,
le tampon par défaut est par ligne généralement. Cela veut dire que la plus
petite unité du fichier lue à la fois est une ligne. C'est pourquoi dans ce cas
il lit une ligne, affiche le résultat, lit la prochaine ligne, affiche le
résultat, etc. Pour des fichiers binaires, la mise en tampon par défaut est
d'un bloc. Cela veut dire que le fichier sera lu bout par bout.  La taille de
ces bouts de fichiers dépend de ce que votre système d'exploitation considère
comme une taille cool.

Vous pouvez contrôler comment la mise en tampon est effectuée en utilisant la
fonction `hSetBuffering`. Elle prend une poignée et un `BufferMode` et retourne
une action I/O qui définit le mode de mise en tampon. `BufferMode` est un
simple type de données énuméré, et les valeurs possibles sont&nbsp;:
`NoBuffering`, `LineBuffering` ou `BlockBuffering (Maybe Int)`. Le `Maybe Int`
permet de préciser la taille des blocs, en octets. Si c'est `Nothing`, alors le
système d'exploitation détermine la taille du bloc. `NoBuffering` signifie que
les caractères sont lus un par un. `NoBuffering` n'est généralement pas
efficace, parce qu'il doit accéder le disque tout le temps.

Voici notre code précédent, sauf qu'il ne lit pas ligne par ligne, mais en
blocs de 2048 octets.

> main = do
>     withFile "something.txt" ReadMode (\handle -> do
>         hSetBuffering handle $ BlockBuffering (Just 2048)
>         contents <- hGetContents handle
>         putStr contents)

Lire des fichiers en plus gros morceaux peut aider à minimiser les accès au
disque, ou lorsque notre fichier est en fait une ressource réseau lente.

On peut aussi utiliser `hFlush`, qui est une fonction qui prend une poignée et
retourne une action I/O qui va vider le tampon du fichier associé à la poignée.
Quand on est en mise en tampon par ligne, le tampon est vidé à chaque nouvelle
ligne. Quand on est en mise en tampon par bloc, le tampon est vidé à chaque
bloc. Il est aussi vidé lorsqu'on ferme la poignée. Cela signifie que lorsqu'on
atteint un caractère de nouvelle ligne, le mécanisme de lecture (ou d'écriture)
rapporte toutes les données qu'il a lues jusqu'ici. Mais on peut utiliser
`hFlush` pour le forcer à rapporter ce qu'il a lu à n'importe quel instant.
Après avoir vidé le tampon en écriture, les données sont disponibles pour
n'importe quel autre programme qui accède au fichier en lecture en même temps.

Pensez à la mise en tampon par bloc comme cela&nbsp;: votre cuvette de
toilettes est faite pour se vider dès qu'elle contient un litre d'eau. Vous
pouvez donc commencer à la remplir d'eau, et dès que vous atteignez un litre,
l'eau est automatiquement vidée, et les données que vous aviez mises dans cette
eau sont lues. Mais vous pouvez aussi vider la cuvette manuellement en
actionnant la chasse d'eau. Cela force la cuvette à se vider, et toute l'eau
(les données) est lue. Au cas où vous n'auriez pas saisi, tirer la chasse d'eau
est une métaphore pour `hFlush`. Ce n'est pas une analogie très sensationnelle
en termes de critères d'analogies dans la programmation, mais je voulais une
analogie avec le monde réel d'un objet qu'on peut vider, pour ma chute.

On a déjà fait un programme pour ajouter un nouvel élément à une liste de
tâches dans *todo.txt*, à présent, faisons un programme qui retire une tâche.
Je vais coller le code, et on va le regarder en détail par la suite ensemble,
pour que vous voyiez que c'est très simple. On va utiliser quelques nouvelles
fonctions sorties de `System.Directory` et une nouvelle fonction de
`System.IO`, mais j'expliquerai cela en temps voulu.

Bon, voici le programme qui retire un élément de *todo.txt*&nbsp;:

> import System.IO
> import System.Directory
> import Data.List
>
> main = do
>     handle <- openFile "todo.txt" ReadMode
>     (tempName, tempHandle) <- openTempFile "." "temp"
>     contents <- hGetContents handle
>     let todoTasks = lines contents
>         numberedTasks = zipWith (\n line -> show n ++ " - " ++ line) [0..] todoTasks
>     putStrLn "These are your TO-DO items:"
>     putStr $ unlines numberedTasks
>     putStrLn "Which one do you want to delete?"
>     numberString <- getLine
>     let number = read numberString
>         newTodoItems = delete (todoTasks !! number) todoTasks
>     hPutStr tempHandle $ unlines newTodoItems
>     hClose handle
>     hClose tempHandle
>     removeFile "todo.txt"
>     renameFile tempName "todo.txt"

Au départ, on ouvre seulement *todo.txt* en lecture, et on lie sa poignée au
nom `handle`.

Ensuite, on utilise une fonction que nous n'avons pas encore rencontrée, qui
vient de `System.IO` - `openTempFile`. Son nom est assez expressif. Elle prend
un chemin vers un répertoire temporaire, et un préfixe de nom, et ouvre un
fichier temporaire. On a utilisé `"."` pour le dossier temporaire, parce que
`.` indique le répertoire courant sur à peu près tous les systèmes
d'exploitation. On a utilisé `"temp"` pour le préfixe de nom du fichier
temporaire, ce qui signifie que le fichier sera nommé *temp* suivi de
caractères aléatoires. Cette fonction retourne une action I/O qui crée le
fichier temporaire, et le résultat de cette action est une paire&nbsp;: le nom
du fichier créé et sa poignée. On pouvait simplement ouvrir un fichier
*todo2.txt* ou quelque chose comme ça, mais il vaut mieux ouvrir un fichier
temporaire à l'aide d'`openTempFile` pour être certain de ne pas en écraser un
autre.

On n'a pas utilisé `getCurrentDirectory` pour récupérer le dossier courant
avant de le passer à `openTempFile` parce que `.` indique le répertoire courant
sous les systèmes Unix ainsi que sous Windows.

Puis, on lie le contenu de *todo.txt* au nom `contents`. Ensuite, on coupe
cette chaîne de caractères en une liste de chaînes de caractères, chacune
contenant une ligne. `todoTasks` est à présent sous la forme `["Iron the
dishes", "Dust the dog", "Take salad out of the oven"]`. On zippe les nombres 0
et suivants avec cette liste à l'aide d'une fonction qui prend un nombre, comme
`3`, et une chaîne comme `"hey"` et retourne `"3 - hey"`, ainsi,
`numberedTasks` est `["0 - Iron the dishes", "1 - Dust the dog" ...`. On joint
cette liste de chaînes en une simple chaîne avec `unlines` et on affiche cette
chaîne sur le terminal. Notez qu'on aurait pu faire `mapM putStrLn
numberedTasks` ici.

On demande ensuite à l'utilisateur laquelle il souhaite effacer. Mettons qu'il
souhaite effacer la numéro 1, `Dust the dog`, donc il tape `1`. `numberString`
est à présent `"1"`, et puisqu'on veut un nombre, et pas une chaîne de
caractères, on utilise `read` sur cela pour obtenir `1` et on le lie à
`number`.

Souvenez-vous de `delete` et `!!` de `Data.List`. `!!` retourne l'élément d'une
liste à l'indice donné, et `delete` supprime la première occurrence d'un élément
dans une liste et retourne une nouvelle liste sans cette occurrence. `(todoTasks
!! number)` (`number` étant `1`) retourne `"Dust the dog"`. On lie `todoTasks`
à laquelle on a supprimé la première occurrence de `"Dust the dog"` à
`newTodoItems`, puis on joint cela en une seule chaîne avec `unlines` avant de
l'écrire dans notre fichier temporaire. L'ancien fichier n'est pas modifié et
le fichier temporaire contient toutes les lignes de l'ancien, à l'exception de
celle qu'on a effacée.

Après cela, on ferme les deux fichiers, on supprime l'ancien avec `removeFile`,
qui, comme vous pouvez le voir, prend un chemin vers un fichier et le supprime.
Après avoir supprimé le vieux *todo.txt*, on utilise `renameFile` pour renommer
le fichier temporaire en *todo.txt*. Faites attention, `removeFile` et
`renameFile` (qui sont dans `System.Directory`) prennent des chemins de
fichiers, et pas des poignées.

Et c'est tout ! On aurait pu faire cela encore plus court, mais on a fait très
attention à ne pas écraser de fichier existant et à demander poliment au
système d'exploitation de nous dire où l'on pouvait mettre notre fichier
temporaire. Essayons à présent !

> $ runhaskell deletetodo.hs
> These are your TO-DO items:
> 0 - Iron the dishes
> 1 - Dust the dog
> 2 - Take salad out of the oven
> Which one do you want to delete?
> 1
>
> $ cat todo.txt
> Iron the dishes
> Take salad out of the oven
>
> $ runhaskell deletetodo.hs
> These are your TO-DO items:
> 0 - Iron the dishes
> 1 - Take salad out of the oven
> Which one do you want to delete?
> 0
>
> $ cat todo.txt
> Take salad out of the oven

<h2 id="arguments-de-ligne-de-commande">
Arguments de ligne de commande
</h2>

<img src="img/arguments.png" alt="ARGUMENTS DANS LA LIGNE DE COMMANDE !!!"
class="right"/>

Gérer les arguments de ligne de commande est plutôt nécessaire si vous voulez
faire un script ou une application à lancer depuis le terminal. Heureusement,
la bibliothèque standard Haskell a un moyen très sympa pour récupérer les
arguments de ligne de commande du programme.

Dans la section précédente, on a fait un programme qui ajoute un élément à une
liste de tâches et un programme pour retirer une tâche. Il y a deux problèmes
avec l'approche choisie. La première, c'est qu'on a codé en dur le nom du
fichier. On a en quelque sorte décidé que le fichier serait nommé *todo.txt* et
que l'utilisateur n'aura jamais à gérer plus d'une liste de tâches.

Un moyen de résoudre ce problème consiste à demander à chaque fois quel fichier
l'utilisateur veut modifier lorsqu'il utilise nos programmes. On a utilisé
cette approche quand on a voulu savoir quel élément l'utilisateur voulait
supprimer. Ça marche, mais ce n'est pas optimal, parce que cela requiert que
l'utilisateur lance le programme, attende que le programme lui demande quelque
chose, et ensuite indique le fichier au programme. Ceci est appelé un programme
interactif, et le problème est le suivant&nbsp;: que faire si l'on souhaite
automatiser l'exécution du programme, comme avec un script ? Il est plus dur de
faire un script qui interagit avec un programme que de faire un script qui
appelle un ou même plusieurs programmes.

C'est pourquoi il est parfois préférable que l'utilisateur dise au programme ce
qu'il veut lorsqu'il lance le programme, plutôt que le programme demande à
l'utilisateur des choses une fois lancé. Et quel meilleur moyen pour
l'utilisateur d'indiquer ce qu'il veut au programme que de donner des arguments
en ligne de commande !

Le module `System.Environment` a deux chouettes actions I/O. L'une est
`getArgs`, qui a pour type `getArgs :: IO [String]` et est une action I/O qui
va récupérer les arguments du programme et les encapsuler dans son résultat
sous forme d'une liste. `getProgName` a pour type `getProgName :: IO String` et
est une action I/O qui contient le nom du programme.

Voici un petit programme qui démontre leur fonctionnement&nbsp;:

> import System.Environment
> import Data.List
>
> main = do
>    args <- getArgs
>    progName <- getProgName
>    putStrLn "The arguments are:"
>    mapM putStrLn args
>    putStrLn "The program name is:"
>    putStrLn progName

On lie `getArgs` et `getProgName` à `args` et `progName`. On dit `The arguments
are:` et ensuite, pour chaque argument dans `args`, on applique `putStrLn`.
Finalement, on affiche aussi le nom du programme. Compilons cela comme
`arg-test`.

> $ ./arg-test first second w00t "multi word arg"
> The arguments are:
> first
> second
> w00t
> multi word arg
> The program name is:
> arg-test

Bien. Armé de cette connaissance, vous pouvez créer des applications en ligne
de commande plutôt sympathiques. En fait, créons-en une dès maintenant. Dans la
section précédente, nous avions créé deux programmes séparés pour ajouter des
tâches et en supprimer. Maintenant, on va faire cela en un seul programme, et
ce qu'il fera dépendra des arguments. On va aussi le faire de manière à ce
qu'il puisse opérer sur différents fichiers, pas seulement *todo.txt*.

On va l'appeler *todo* ("à faire") et il servira à faire (haha !) trois choses
différentes&nbsp;:

* Voir des tâches
* Ajouter des tâches
* Supprimer des tâches

On se fichera un peu des erreurs d'entrée pour l'instant.

Notre programme sera fait de façon à ce que si l'on souhaite ajouter la tâche
`Find the magic sword of power` au fichier *todo.txt*, on ait simplement à
faire `todo add todo.txt "Find the magic sword of power"` dans notre terminal.
Pour voir les tâches, on fera `todo view todo.txt` et pour supprimer la tâche
qui a pour indice 2, on fera `todo remove todo.txt 2`.

On va commencer par créer une liste associative de résolution. Ce sera une
simple liste associative qui aura pour clés des arguments de ligne de commande,
et pour valeurs une fonction correspondante. Ces fonctions auront toute pour
type `[String] -> IO ()`. Elles prendront en paramètre la liste des arguments,
et retourneront une action I/O qui fera l'affichage, l'ajout, la suppression,
etc.

> import System.Environment
> import System.Directory
> import System.IO
> import Data.List
>
> dispatch :: [(String, [String] -> IO ())]
> dispatch =  [ ("add", add)
>             , ("view", view)
>             , ("remove", remove)
>             ]

Il nous reste encore à définir `main`, `add`, `view` et `remove`, commençons
par `main`&nbsp;:

> main = do
>     (command:args) <- getArgs
>     let (Just action) = lookup command dispatch
>     action args

D'abord, on récupère les arguments et on les lie à `(command:args)`. Si vous
vous souvenez de votre filtrage par motif, cela signifie que le premier
argument est lié à `command` et que le reste est lié à `args`. Si on appelle
notre programme en faisant `todo add todo.txt "Spank the monkey"`, `command`
sera `"add"` et `args` sera `["todo.xt", "Spank the monkey"]`.

À la prochaine ligne, on cherche notre commande dans la liste de résolution.
Puisque `"add"` pointe vers `add`, on récupère `Just add` en résultat. On
utilise à nouveau un filtrage par motifs pour sortir notre fonction du `Maybe`.
Que se passe-t-il si notre commande ne fait pas partie de la liste de
résolution ? Eh bien la résolution retournera `Nothing`, mais comme on a dit
qu'on ne se souciait pas trop de ça, le filtrage va échouer et notre programme
va lancer une exception.

Finalement, on appelle notre fonction `action` avec le reste de la liste des
arguments. Cela retourne une action I/O qui ajoute un élément, affiche les
éléments ou supprime un élément, et puisque cette action fait partie du bloc
*do* de `main`, elle sera exécutée. Si on suit notre exemple concret, jusqu'ici
`action` vaut `add`, et sera appelée avec `args` (donc `["todo.txt", "Spank the
monkey"]`) et retournera une action I/O qui ajoute `Spank the monkey` à
*todo.txt*.

Génial ! Il ne reste plus qu'à implémenter `add`, `view` et `remove`.
Commençons par `add`&nbsp;:

> add :: [String] -> IO ()
> add [fileName, todoItem] = appendFile fileName (todoItem ++ "\n")

Si on appelle notre programme avec `todo add todo.txt "Spank the monkey"`, le
`"add"` sera lié à `command` dans le premier filtrage du bloc `main`, alors que
`["todo.txt", "Spank the monkey"]` sera passé à la fonction obtenue dans la
liste de résolution. Donc, puisqu'on ne se soucie pas des mauvaises entrées, on
filtre simplement cela contre une liste à deux éléments, et on retourne une
action I/O qui ajoute cette ligne à la fin du fichier, avec un caractère de
retour à la ligne.

Ensuite, implémentons la fonctionnalité d'affichage. Si on veut voir les
éléments d'un fichier, on fait `todo view todo.txt`. Donc dans le premier
filtrage par motif, `command` sera `"view"` et `args` sera `["todo.txt"]`.

> view :: [String] -> IO ()
> view [fileName] = do
>     contents <- readFile fileName
>     let todoTasks = lines contents
>         numberedTasks = zipWith (\n line -> show n ++ " - " ++ line) [0..] todoTasks
>     putStr $ unlines numberedTasks

On a déjà fait à peu près la même chose dans le programme qui n'effaçait les
tâches que quand on les avait affichées afin que l'utilisateur en choisisse une
à supprimer, seulement ici, on ne fait qu'afficher.

Et enfin, on va implémenter `remove`. Ce sera très similaire au programme qui
effaçait une tâche, donc si vous ne comprenez pas comment la suppression se
passe ici, allez relire l'explication sous ce programme. La différence
principale, c'est qu'on ne code pas le nom *todo.txt* en dur mais qu'on
l'obtient en argument. Aussi, on ne demande pas à l'utilisateur de choisir un
numéro puisqu'on l'obtient également en argument.

> remove :: [String] -> IO ()
> remove [fileName, numberString] = do
>     handle <- openFile fileName ReadMode
>     (tempName, tempHandle) <- openTempFile "." "temp"
>     contents <- hGetContents handle
>     let number = read numberString
>         todoTasks = lines contents
>         newTodoItems = delete (todoTasks !! number) todoTasks
>     hPutStr tempHandle $ unlines newTodoItems
>     hClose handle
>     hClose tempHandle
>     removeFile fileName
>     renameFile tempName fileName

On a ouvert le fichier basé sur `fileName` et ouvert un fichier temporaire,
supprimé la ligne avec l'indice donné par l'utilisateur, écrit cela dans le
fichier temporaire, supprimé le fichier original et renommé le fichier
temporaire en `fileName`.

Voilà le programme final en entier, dans toute sa splendeur !

> import System.Environment
> import System.Directory
> import System.IO
> import Data.List
>
> dispatch :: [(String, [String] -> IO ())]
> dispatch =  [ ("add", add)
>             , ("view", view)
>             , ("remove", remove)
>             ]
>
> main = do
>     (command:args) <- getArgs
>     let (Just action) = lookup command dispatch
>     action args
>
> add :: [String] -> IO ()
> add [fileName, todoItem] = appendFile fileName (todoItem ++ "\n")
>
> view :: [String] -> IO ()
> view [fileName] = do
>     contents <- readFile fileName
>     let todoTasks = lines contents
>         numberedTasks = zipWith (\n line -> show n ++ " - " ++ line) [0..] todoTasks
>     putStr $ unlines numberedTasks
>
> remove :: [String] -> IO ()
> remove [fileName, numberString] = do
>     handle <- openFile fileName ReadMode
>     (tempName, tempHandle) <- openTempFile "." "temp"
>     contents <- hGetContents handle
>     let number = read numberString
>         todoTasks = lines contents
>         newTodoItems = delete (todoTasks !! number) todoTasks
>     hPutStr tempHandle $ unlines newTodoItems
>     hClose handle
>     hClose tempHandle
>     removeFile fileName
>     renameFile tempName fileName

<img src="img/salad.png" alt="salade fraîchement cuisinée" class="left"/>

Pour résumer notre solution&nbsp;: on a fait une liste associative de
résolution qui associe à chaque commande une fonction qui prend des arguments
de la ligne de commande et retourne une action I/O. On regarde ce qu'est la
commande, et en fonction de ça on résout l'appel sur la fonction appropriée de
la liste de résolution. On appelle cette fonction avec le reste des arguments
pour obtenir une action I/O qui fera l'action attendue et ensuite on exécute
cette action !

Dans d'autres langages, on aurait pu implémenter ceci avec un gros *switch
case* ou ce genre de structure, mais utiliser des fonctions d'ordre supérieure
nous permet de demander à la liste de résolution de nous donner une fonction,
puis de demander à cette fonction une action I/O correspondant à nos arguments.

Testons cette application !

> $ ./todo view todo.txt
> 0 - Iron the dishes
> 1 - Dust the dog
> 2 - Take salad out of the oven
>
> $ ./todo add todo.txt "Pick up children from drycleaners"
>
> $ ./todo view todo.txt
> 0 - Iron the dishes
> 1 - Dust the dog
> 2 - Take salad out of the oven
> 3 - Pick up children from drycleaners
>
> $ ./todo remove todo.txt 2
>
> $ ./todo view todo.txt
> 0 - Iron the dishes
> 1 - Dust the dog
> 2 - Pick up children from drycleaners

Une autre chose cool à propos de ça, c'est qu'il est très facile d'ajouter de
nouvelles fonctionnalités. Ajoutez simplement une entrée dans la liste de
résolution et implémentez la fonction correspondante, les doigts dans le nez !
Comme exercice, vous pouvez implémenter la fonction `bump` qui prend un fichier
et un numéro de tâche, et retourne une action I/O qui pousse cette tâche en
tête de la liste de tâches.

Vous pourriez aussi faire échouer ce programme plus gracieusement dans le cas
d'une entrée mal formée (par exemple, si quelqu'un lance `todo UP YOURS
HAHAHAHA`) en faisant une action I/O qui rapporte une erreur (disons,
`errorExit :: IO ()`), puis en vérifiant si l'entrée est erronée, et le cas
échéant, en utilisant cette action. Un autre moyen est d'utiliser les
exceptions, qu'on va bientôt rencontrer.

<h2 id="aleatoire">
Aléatoire
</h2>

<img src="img/random.png" alt="cette image est la source d'aléatoire ultime"
class="right"/>

Souvent quand on programme, on a besoin de données aléatoires. Par exemple,
lorsque vous faites un jeu où un dé doit être lancé, ou quand vous voulez
générer des entrées pour tester votre programme. Des données aléatoires peuvent
avoir plein d'utilisations en programmation. En fait, je devrais dire
pseudo-aléatoire, puisqu'on sait tous que la seule source de vrai aléatoire est
un singe sur un monocycle tenant un fromage dans une main et ses fesses dans
l'autre. Dans cette section, on va voir comment Haskell génère des données
quasiment aléatoires.

Dans la plupart des langages de programmation, vous avez des fonctions qui vous
donnent un nombre aléatoire. Chaque fois que vous appelez cette fonction, vous
obtenez (on l'espère) un nombre aléatoire différent. Quid d'Haskell ? Eh bien,
souvenez-vous, Haskell est un langage fonctionnel pur. Cela signifie qu'il a la
propriété de transparence référentielle. Ce que CELA signifie, c'est qu'une
fonction à laquelle on donne les mêmes paramètres plusieurs fois retournera
toujours le même résultat. C'est très cool, parce que ça nous permet de
raisonner différemment à propos de nos programmes, et de retarder l'évaluation
jusqu'à ce qu'elle soit nécessaire. Si j'appelle une fonction, je peux être
certain qu'elle ne va pas faire des choses folles avant de me donner son
résultat. Tout ce qui importe, c'est son résultat. Cependant, cela rend un peu
difficile les choses dans le cas des nombres aléatoires. Si j'ai une fonction
comme ça&nbsp;:

> randomNumber :: (Num a) => a
> randomNumber = 4

Ce n'est pas très utile comme fonction de nombre aléatoire parce qu'elle
retourne toujours `4`, bien que je puisse vous garantir que ce 4 est totalement
aléatoire puisque j'ai lancé un dé pour le déterminer.

Comment les autres langages font-ils des nombres apparemment aléatoires ? Eh
bien, ils prennent différentes informations de l'ordinateur, comme l'heure
actuelle, combien et comment vous avez déplacé votre souris, quels genres de
bruits vous faites devant votre ordinateur, et mélangent tout ça pour vous
donner un nombre qui a l'air aléatoire. La combinaison de ces facteurs
(l'aléatoire) est probablement différente à chaque instant, donc vous obtenez
un nombre aléatoire différent.

Ah. Donc en Haskell, on peut faire un nombre aléatoire en faisant une fonction
qui prend en paramètre cet aléatoire et, basé sur ceci, retourne un nombre (ou
un autre type de données).

Pénétrez dans le module `System.Random`. Il a toutes les fonctions qui
satisfont notre besoin d'aléatoire. Plongeons donc dans l'une des fonctions
qu'il exporte, j'ai nommé `random`. Voici son type&nbsp;: `random :: (RandomGen
g, Random a) => g -> (a, g)`. Ouah ! Que de nouvelles classes de types dans
cette déclaration ! La classe `RandomGen` est pour les types qui peuvent agir
comme des sources d'aléatoire. La classe de types `Random` est pour les choses
qui peuvent avoir une valeur aléatoire. Un booléen peut prendre une valeur
aléatoire, soit `True` soit `False`. Un nombre peut prendre une pléthore de
différentes valeurs aléatoires. Est-ce qu'une fonction peut prendre une valeur
aléatoire ? Je ne pense pas, probablement pas ! Si l'on essaie de traduire la
déclaration de `random`, cela donne quelque chose comme&nbsp;: elle prend un
générateur aléatoire (c'est notre source d'aléatoire) et retourne une valeur
aléatoire et un nouveau générateur aléatoire. Pourquoi retourne-t-elle un
nouveau générateur en plus de la valeur aléatoire ? Eh bien, on va voir ça dans
un instant.

Pour utiliser notre fonction `random`, il nous faut obtenir un de ces
générateurs aléatoires. Le module `System.Random` exporte un type cool,
`StdGen`, qui est une instance de la classe `RandomGen`. On peut soit créer
notre `StdGen` nous-même, soit demander au système de nous en faire un basé sur
une multitude de choses aléatoires.

Pour créer manuellement un générateur aléatoire, utilisez la fonction
`mkStdGen`. Elle a pour type `mkStdGen :: Int -> StdGen`. Elle prend un entier
et en fonction de celui-ci, nous donne un générateur aléatoire. Ok, essayons
d'utiliser `random` et `mkStdGen` en tandem pour obtenir un nombre (pas très
aléatoire…).

> ghci> random (mkStdGen 100)

> <interactive>:1:0:
>     Ambiguous type variable `a' in the constraint:
>       `Random a' arising from a use of `random' at <interactive>:1:0-20
>     Probable fix: add a type signature that fixes these type variable(s)

De quoi ? Ah, oui, la fonction `random` peut retourner une valeur de n'importe
quel type membre de la classe `Random`, on doit donc informer Haskell du type
qu'on désire. N'oublions tout de même pas qu'elle retourne une valeur aléatoire
et un générateur aléatoire sous forme de paire.

> ghci> random (mkStdGen 100) :: (Int, StdGen)
> (-1352021624,651872571 1655838864)

Enfin ! Un nombre qui a l'air un peu aléatoire ! La première composante du
tuple est notre nombre, alors que la seconde est la représentation textuelle du
nouveau générateur. Que se passe-t-il si l'on appelle `random` à nouveau, avec
le même générateur ?

> ghci> random (mkStdGen 100) :: (Int, StdGen)
> (-1352021624,651872571 1655838864)

Bien sûr. Le même résultat pour les mêmes paramètres. Essayons de donner un
générateur aléatoire différent comme paramètre.

> ghci> random (mkStdGen 949494) :: (Int, StdGen)
> (539963926,466647808 1655838864)

Bien, cool, super, un nombre différent. On peut utiliser les annotations de
type pour obtenir différents types de cette fonction.

> ghci> random (mkStdGen 949488) :: (Float, StdGen)
> (0.8938442,1597344447 1655838864)
> ghci> random (mkStdGen 949488) :: (Bool, StdGen)
> (False,1485632275 40692)
> ghci> random (mkStdGen 949488) :: (Integer, StdGen)
> (1691547873,1597344447 1655838864)

Créons une fonction qui simule trois lancers de pièce. Si `random` ne
retournait pas un nouveau générateur avec la valeur aléatoire, on devrait
donner à cette fonction trois générateurs aléatoires en paramètre, et retourner
le jet de pièce pour chacun des trois. Mais ça semble mauvais, parce que si un
générateur peut retourner une valeur aléatoire de type `Int` (qui peut prendre
énormément de valeurs), il devrait pouvoir renvoyer un jet de trois pièces (qui
ne peut prendre que huit valeurs précisément). C'est ici que le fait que
`random` retourne un nouveau générateur s'avère très utile.

On va représenter une pièce avec un simple `Bool`. `True` pour pile, `False`
pour face.

> threeCoins :: StdGen -> (Bool, Bool, Bool)
> threeCoins gen =
>     let (firstCoin, newGen) = random gen
>         (secondCoin, newGen') = random newGen
>         (thirdCoin, newGen'') = random newGen'
>     in  (firstCoin, secondCoin, thirdCoin)

On appelle `random` avec le générateur passé en paramètre pour obtenir un jet
et un nouveau générateur. On l'appelle à nouveau avec le nouveau générateur,
pour obtenir un deuxième jet. On fait de même pour le troisième. Si on avait
appelé à chaque fois avec le même générateur, toutes les pièces auraient eu la
même valeur, et on aurait seulement pu avoir `(False, False, False)` ou `(True,
True, True)` comme résultat.

> ghci> threeCoins (mkStdGen 21)
> (True,True,True)
> ghci> threeCoins (mkStdGen 22)
> (True,False,True)
> ghci> threeCoins (mkStdGen 943)
> (True,False,True)
> ghci> threeCoins (mkStdGen 944)
> (True,True,True)

Remarquez que l'on n'a pas eu à faire `random gen :: (Bool, StdGen)`. C'est
parce que nous avions déjà spécifié que l'on voulait des booléens dans la
déclaration de type de la fonction. C'est pourquoi Haskell peut inférer qu'on
veut une valeur booléenne dans ce cas.

Et si l'on veut lancer quatre pièces ? Ou cinq ? Eh bien, il y a une fonction
`randoms` qui prend un générateur, et retourne une liste infinie de valeurs
basées sur ce générateur.

> ghci> take 5 $ randoms (mkStdGen 11) :: [Int]
> [-1807975507,545074951,-1015194702,-1622477312,-502893664]
> ghci> take 5 $ randoms (mkStdGen 11) :: [Bool]
> [True,True,True,True,False]
> ghci> take 5 $ randoms (mkStdGen 11) :: [Float]
> [7.904789e-2,0.62691015,0.26363158,0.12223756,0.38291094]

Pourquoi `randoms` ne retourne pas de nouveau générateur avec la liste ? On
peut implémenter `randoms` très facilement ainsi&nbsp;:

> randoms' :: (RandomGen g, Random a) => g -> [a]
> randoms' gen = let (value, newGen) = random gen in value:randoms' newGen

Une définition récursive. On obtient une valeur aléatoire et un nouveau
générateur à partir du générateur courant, et on crée une liste qui contient la
valeur aléatoire en tête, et une liste de nombres aléatoires obtenue par le
nouveau générateur en queue. Puisqu'on doit potentiellement générer une liste
infinie de nombres, on ne peut pas renvoyer le nouveau générateur.

On pourrait faire une fonction qui génère un flot fini de nombres aléatoires et
un nouveau générateur ainsi&nbsp;:

> finiteRandoms :: (RandomGen g, Random a, Num n) => n -> g -> ([a], g)
> finiteRandoms 0 gen = ([], gen)
> finiteRandoms n gen =
>     let (value, newGen) = random gen
>         (restOfList, finalGen) = finiteRandoms (n-1) newGen
>     in  (value:restOfList, finalGen)

Encore, une définition récursive. On dit que si l'on ne veut aucun nombre, on
retourne la liste vide et le générateur qu'on nous a donné. Pour tout autre
nombre de valeurs aléatoires, on récupère une première valeur aléatoire et un
nouveau générateur. Ce sera la tête. Et on dit que la queue sera composée de *n
- 1* nombres générés à partir du nouveau générateur. Enfin, on renvoie la tête
jointe à la queue, ainsi que le générateur obtenu par l'appel récursif.

Et si l'on voulait une valeur aléatoire dans un certain intervalle ? Tous les
entiers aléatoires rencontrés jusqu'à présent étaient outrageusement grands ou
petits. Si l'on voulait lancer un dé ? On utilise `randomR` à cet effet. Elle a
pour type `randomR :: (RandomGen g, Random a) => (a, a) -> g -> (a, g)`,
signifiant qu'elle est comme `random`, mais prend en premier paramètre une
paire de valeurs qui définissent une borne inférieure et une borne supérieure
pour la valeur produite.

> ghci> randomR (1,6) (mkStdGen 359353)
> (6,1494289578 40692)
> ghci> randomR (1,6) (mkStdGen 35935335)
> (3,1250031057 40692)

Il y a aussi `randomRs`, qui produit un flot de valeurs aléatoires dans
l'intervalle spécifié. Regardez ça&nbsp;:

> ghci> take 10 $ randomRs ('a','z') (mkStdGen 3) :: [Char]
> "ndkxbvmomg"

Super, on dirait un mot de passe ultra secret ou quelque chose comme ça.

Vous vous demandez peut-être ce que cette section vient faire dans le chapitre
sur les entrées-sorties ? On n'a pas fait d'I/O jusqu'ici. Eh bien, jusqu'ici,
on a créé notre générateur manuellement avec un entier arbitraire. Le problème
si l'on fait ça dans nos vrais programmes, c'est qu'ils retourneront toujours
les mêmes suites de nombres aléatoires, ce qui ne nous convient pas. C'est
pourquoi `System.Random` offre l'action I/O `getStdGen`, qui a pour type `IO
StdGen`.  Lorsque votre programme débute, il demande au système un bon
générateur aléatoire et le stocke comme un générateur global. `getStdGen` vous
récupère ce générateur lorsque vous le liez à un nom.

Voici un simple programme qui génère une chaîne aléatoire.

> import System.Random
>
> main = do
>     gen <- getStdGen
>     putStr $ take 20 (randomRs ('a','z') gen)

> $ runhaskell random_string.hs
> pybphhzzhuepknbykxhe
> $ runhaskell random_string.hs
> eiqgcxykivpudlsvvjpg
> $ runhaskell random_string.hs
> nzdceoconysdgcyqjruo
> $ runhaskell random_string.hs
> bakzhnnuzrkgvesqplrx

Attention cependant, faire `getStdGen` deux fois vous donnera le même
générateur global deux fois. Donc si vous faites&nbsp;:

> import System.Random
>
> main = do
>     gen <- getStdGen
>     putStrLn $ take 20 (randomRs ('a','z') gen)
>     gen2 <- getStdGen
>     putStr $ take 20 (randomRs ('a','z') gen2)

vous obtiendrez la même chaîne deux fois ! Un moyen d'obtenir deux chaînes de
longueur 20 est de mettre en place un flot infini de caractères, de prendre les
20 premiers, les afficher sur une ligne, puis prendre les 20 suivants et les
afficher sur une seconde ligne. Pour cela, on peut utiliser `splitAt` de
`Data.List`, qui coupe une liste à un indice donné et retourne le tuple formé
par la partie coupée en première composante, et le reste en seconde composante.

> import System.Random
> import Data.List
>
> main = do
>     gen <- getStdGen
>     let randomChars = randomRs ('a','z') gen
>         (first20, rest) = splitAt 20 randomChars
>         (second20, _) = splitAt 20 rest
>     putStrLn first20
>     putStr second20

Un autre moyen est d'utiliser l'action `newStdGen`, qui coupe notre générateur
courant en deux générateurs. Elle remplace le générateur global par l'un deux,
et encapsule l'autre comme son résultat.

> import System.Random
>
> main = do
>     gen <- getStdGen
>     putStrLn $ take 20 (randomRs ('a','z') gen)
>     gen' <- newStdGen
>     putStr $ take 20 (randomRs ('a','z') gen')

Non seulement on obtient un nouveau générateur quand on lie `newStdGen` à un
nom, mais en plus le générateur global est changé, donc si on fait `getStdGen`
à nouveau et qu'on le lie à un nom, on obtiendra un générateur différent de
`gen`.

Voici un petit programme qui fait deviner à l'utilisateur le numéro auquel il
pense.

> import System.Random
> import Control.Monad(when)
>
> main = do
>     gen <- getStdGen
>     askForNumber gen
>
> askForNumber :: StdGen -> IO ()
> askForNumber gen = do
>     let (randNumber, newGen) = randomR (1,10) gen :: (Int, StdGen)
>     putStr "Which number in the range from 1 to 10 am I thinking of? "
>     numberString <- getLine
>     when (not $ null numberString) $ do
>         let number = read numberString
>         if randNumber == number
>             then putStrLn "You are correct!"
>             else putStrLn $ "Sorry, it was " ++ show randNumber
>         askForNumber newGen

<img src="img/jackofdiamonds.png" alt="valet de carreau" class="left"/>

On crée une fonction `askForNumber`, qui prend un générateur aléatoire et
retourne une action I/O qui demande un nombre à l'utilisateur et lui dit s'il a
bien deviné. Dans cette fonction, on génère d'abord un nombre aléatoire et un
nouveau générateur basés sur le générateur obtenu en paramètre, et on les nomme
respectivement `randNumber` et `newGen`. Disons que le nombre généré était `7`.
On demande ensuite à l'utilisateur de deviner à quel nombre on pense. On fait
`getLine` et lie le résultat à `numberString`. Quand l'utilisateur tape `7`,
`numberString` devient `"7"`. Ensuite, on utilise `when` pour vérifier si la
chaîne entrée par l'utilisateur est vide. Si elle l'est, une action I/O vide
`return ()` est exécutée, qui termine le programme. Sinon, l'action combinée de
ce bloc *do* est effectuée. On utilise `read` sur `numberString` pour la
convertir en nombre, donc `number` est `7`.

<div class="hintbox">

**Excusez-moi !** Si l'utilisateur nous donne ici une entrée que `read` ne peut
pas lire (comme `"haha"`), notre programme va planter avec un message d'erreur
horrible. Si vous ne voulez pas que votre programme plante sur une entrée
erronée, utilisez `reads`, qui retourne une liste vide quand elle n'arrive pas
à lire la chaîne. Quand elle y parvient, elle retourne une liste singleton avec
notre valeur en première composante, et le reste de la chaîne qu'elle n'a pas
consommé dans l'autre composante.

</div>

On vérifie si le nombre qu'on a entré est égal à celui généré aléatoirement et
on donne à l'utilisateur le message approprié. Puis on appelle `askForNumber`
récursivement, seulement avec le nouveau générateur qu'on a obtenu, ce qui nous
donne une nouvelle action I/O qui sera comme celle qu'on vient d'exécuter, mais
dépendra d'un générateur différent.

`main` consiste en la récupération d'un générateur aléatoire du système, suivie
d'un appel à `askForNumber` avec celui-ci pour obtenir l'action initiale.

Voici notre programme en action !

> $ runhaskell guess_the_number.hs
> Which number in the range from 1 to 10 am I thinking of? 4
> Sorry, it was 3
> Which number in the range from 1 to 10 am I thinking of? 10
> You are correct!
> Which number in the range from 1 to 10 am I thinking of? 2
> Sorry, it was 4
> Which number in the range from 1 to 10 am I thinking of? 5
> Sorry, it was 10
> Which number in the range from 1 to 10 am I thinking of?

Une autre manière d'écrire le même programme est comme suit&nbsp;:

> import System.Random
> import Control.Monad(when)
>
> main = do
>     gen <- getStdGen
>     let (randNumber, _) = randomR (1,10) gen :: (Int, StdGen)
>     putStr "Which number in the range from 1 to 10 am I thinking of? "
>     numberString <- getLine
>     when (not $ null numberString) $ do
>         let number = read numberString
>         if randNumber == number
>             then putStrLn "You are correct!"
>             else putStrLn $ "Sorry, it was " ++ show randNumber
>         newStdGen
>         main

C'est très similaire à la version précédente, mais plutôt que de faire une
fonction qui prend un générateur et s'appelle récursivement avec un nouveau
générateur, on fait tout le travail dans `main`. Après avoir dit à
l'utilisateur s'il a correctement deviné ou pas, on met à jour le générateur
global et on appelle `main` à nouveau. Les deux approches sont valides, mais je
préfère la première parce qu'elle fait moins de choses dans `main` et nous
offre une fonction facilement réutilisable.

<h2 id="chaines-d-octets">
Chaînes d'octets
</h2>

<img src="img/chainchomp.png" alt="comme des chaînes normales, mais qui veulent
vous croctets... quelle mauvaise blague" class="right"/>

Les listes sont des structures de données cool et utiles. Jusqu'ici, on les a
utilisées à peu près partout. Il y a une multitude de fonctions opérant sur
elles et la paresse d'Haskell nous permet d'échanger les boucles *for* et
*while* des autres langages contre des filtrages et des mappages sur des
listes, parce que l'évaluation n'aura lieu que lorsque cela sera nécessaire,
donc des choses comme des listes infinies (et même des listes infinies de
listes infinies !) ne nous posent pas de problème. C'est pourquoi les listes
peuvent être utilisées pour représenter les flots, que ce soit en lecture
depuis l'entrée standard ou un fichier. On peut juste ouvrir un fichier, et le
lire comme une chaîne de caractères, alors qu'en réalité il ne sera accédé que
quand ce sera nécessaire.

Cependant, traiter les fichiers comme des listes a un inconvénient&nbsp;: ça a
tendance à être assez lent. Comme vous le savez, `String` est un synonyme de
type pour `[Char]`. Les `Char` n'ont pas une taille fixe, parce qu'il faut
plusieurs octets pour représenter un caractère, par exemple Unicode. De plus,
les listes sont vraiment paresseuses. Si vous avez une liste comme `[1, 2, 3,
4]`, elle ne sera évaluée que lorsque ce sera vraiment nécessaire. La liste
entière est une promesse de liste. Rappelez-vous que `[1, 2, 3, 4]` est un
sucre syntaxique pour `1:2:3:4:[]`. Lorsque le premier élément de la liste est
forcé à être évalué (par exemple, en l'affichant), le reste de la liste
`2:3:4:[]` est toujours une promesse de liste, et ainsi de suite. Vous pouvez
donc imaginer les listes comme des promesses que l'élément suivant sera délivré
quand on en aura besoin, ainsi que la promesse que la suite fera pareil. Il ne
faut pas se creuser l'esprit bien longtemps pour se dire que traiter une simple
liste de nombres comme une série de promesses n'est peut-être pas la manière la
plus efficace au monde.

Ce coût supplémentaire ne nous dérange pas la plupart du temps, mais il s'avère
handicapant lorsque l'on lit et manipule des gros fichiers. C'est pourquoi
Haskell a des **chaînes d'octets**. Les chaînes d'octets sont un peu comme des
listes, seulement chaque élément fait un octet (ou 8 bits) de taille. La
manière dont elles sont paresseuses est aussi différente.

Les chaînes d'octets viennent sous deux déclinaisons&nbsp;: les strictes et les
paresseuses. Les chaînes d'octets strictes résident dans `Data.ByteString` et
elles abandonnent complètement la paresse. Plus de promesses impliquées, une
chaîne d'octets stricte est une série d'octets dans un tableau. Vous ne pouvez
pas avoir de chaîne d'octets stricte infinie. Si vous évaluez le premier octet
d'une chaîne stricte, elle est évaluée en entier. Le bon côté des choses, c'est
qu'il y a moins de coût supplémentaire puisqu'il n'y a plus de glaçons (le
terme technique pour les promesses) impliqués. Le mauvais côté, c'est qu'elles
risquent plus de remplir votre mémoire, parce qu'elles sont lues entièrement
dans la mémoire d'un coup.

L'autre variété de chaîne d'octets réside dans `Data.ByteString.Lazy`. Elles
sont paresseuses, mais pas autant que les listes. Comme on l'a dit plus tôt, il
y a autant de glaçons dans une liste que d'éléments dans la liste. C'est ce qui
les rend un peu lentes pour certaines opérations. Les chaînes d'octets
paresseuses prennent une approche différente - elles sont stockées dans des
morceaux (à ne pas confondre avec des glaçons !), chaque morceau ayant une
taille de 64K. Donc, lorsque vous évaluez un octet d'une chaîne d'octets
paresseuse (en l'affichant ou autre), les premiers 64K sont évalués. Après
cela, c'est juste une promesse pour le reste des morceaux. Les chaînes d'octets
sont un peu comme des listes de chaînes d'octets strictes de taille 64K. Quand
vous traitez un fichier avec des chaînes d'octets paresseuses, il sera lu
morceau par morceau. C'est cool parce que cela ne causera pas une montée en
flèche de l'utilisation mémoire et les 64K tiennent probablement correctement
dans le cache L2 de votre CPU.

Si vous lisez la
[documentation](http://www.haskell.org/ghc/docs/latest/html/libraries/bytestring/Data-ByteString-Lazy.html)
de `Data.ByteString.Lazy`, vous verrez qu'il a beaucoup de fonctions qui ont
les mêmes noms que celles de `Data.List`, seulement les signatures de type ont
`ByteString` au lieu de `[a]` et `Word8` au lieu de `a`. Les fonctions ayant le
même nom fonctionnent principalement identiquement à celles sur les listes.
Puisque les noms sont identiques, on va faire un import qualifié dans un script
et charger ce script dans GHCi pour jouer avec les chaînes d'octets.

> import qualified Data.ByteString.Lazy as B
> import qualified Data.ByteString as S

`B` contient les chaînes d'octets paresseuses, alors que `S` contient les
strictes. On utilisera principalement les paresseuses.

La fonction `pack` a pour signature de type `pack :: [Word8] -> ByteString`.
Cela signifie qu'elle prend une liste d'octets de type `Word8` et retourne une
`ByteString`. Vous pouvez l'imaginer comme prenant une liste, qui est
paresseuse, et la rendant moins paresseuse, c'est-à-dire seulement paresseuse à
chaque intervalle de 64K.

C'est quoi ce type `Word8` au fait ? Eh bien, c'est comme `Int`, mais avec un
plus petit intervalle de valeurs, c'est à dire 0 à 255. Cela représente un
nombre sur 8 bits. Tout comme `Int`, il est dans la classe de types `Num`. Par
exemple, on sait que la valeur `5` est polymorphe et peut se faire passer pour
n'importe quel type numérique. Eh bien elle peut avoir pour type `Word8`.

> ghci> B.pack [99,97,110]
> Chunk "can" Empty
> ghci> B.pack [98..120]
> Chunk "bcdefghijklmnopqrstuvwx" Empty

Comme vous le voyez, vous n'avez généralement pas trop à vous soucier de
`Word8`, parce que le système de types peut faire choisir aux nombres ce type.
Si vous essayez un nombre trop gros, comme `336`, il sera juste modulé à `80`.

On a juste placé une poignée de valeurs dans une `ByteString`, donc elles
tenaient dans un seul morceau. `Empty` est comme `[]` des listes.

`unpack` est la fonction inverse de `pack`. Elle prend une chaîne d'octets et
la transforme en liste d'octets.

`fromChunks` prend une liste de chaînes d'octets strictes et la convertit en
une chaîne d'octets paresseuse. `toChunks` prend une chaîne d'octets paresseuse
et la convertit en une liste de chaînes d'octets strictes.

> ghci> B.fromChunks [S.pack [40,41,42], S.pack [43,44,45], S.pack [46,47,48]]
> Chunk "()*" (Chunk "+,-" (Chunk "./0" Empty))

C'est bien lorsque vous avez beaucoup de petites chaînes d'octets strictes et
que vous voulez les traiter efficacement sans les joindre en une grosse chaîne
stricte en mémoire.

La version chaîne d'octets de `:` est appelée `cons`. Elle prend un octet et
une chaîne d'octets et place l'octet au début de la chaîne. Ceci est paresseux,
donc elle va créer un nouveau morceau, même si le morceau précédent n'était pas
rempli. C'est pourquoi il vaut mieux utiliser la version stricte de `cons`,
`cons'` si vous voulez insérez plein d'octets au début d'une chaîne d'octets.

> ghci> B.cons 85 $ B.pack [80,81,82,84]
> Chunk "U" (Chunk "PQRT" Empty)
> ghci> B.cons' 85 $ B.pack [80,81,82,84]
> Chunk "UPQRT" Empty
> ghci> foldr B.cons B.empty [50..60]
> Chunk "2" (Chunk "3" (Chunk "4" (Chunk "5" (Chunk "6" (Chunk "7" (Chunk "8" (Chunk "9" (Chunk ":" (Chunk ";" (Chunk "<"
> Empty))))))))))
> ghci> foldr B.cons' B.empty [50..60]
> Chunk "23456789:;<" Empty

Comme vous pouvez le constater, `empty` crée une chaîne d'octets vide. Vous
voyez la différence entre `cons` et `cons'` ? Avec `foldr`, on est parti d'une
chaîne d'octets vide, et on a ajouté tous les nombres d'une liste en partant de
la droite au début de cette chaîne. Quand on a utilisé `cons`, on s'est
retrouvé avec un morceau pour chaque octet, ce qui détruit l'utilité de la
chaîne.

Autrement, les modules pour les chaînes d'octets ont une pelletée de fonctions
analogues à celles de `Data.List`, incluant, mais non limitées à, `head`,
`tail`, `init`, `null`, `length`, `map`, `reverse`, `foldl`, `foldr`, `concat`,
`takeWhile`, `filter`, etc.

Ils ont aussi des fonctions qui ont le même nom que certaines des fonctions de
`System.IO`, mais avec `ByteString` à la place de `String`. Par exemple,
`readFile` de `System.IO` a pour type `readFile :: FilePath -> IO String`,
alors que `readFile` des modules de chaînes d'octets a pour type `readFile ::
FilePath -> IO ByteString`. Attention, si vous utilisez des chaînes d'octets
strictes et que vous essayez de lire un fichier, il sera lu en entier en
mémoire d'un coup ! Avec des chaînes d'octets paresseuses, il sera lu par
morceaux.

Créons un simple programme qui prend deux noms de fichiers en arguments et
copie le premier fichier dans le second. Notez que `System.Directory` a déjà
une fonction `copyFile`, mais on va implémenter notre propre fonction de copie
pour ce programme de toute façon.

> import System.Environment
> import qualified Data.ByteString.Lazy as B
>
> main = do
>     (fileName1:fileName2:_) <- getArgs
>     copyFile fileName1 fileName2
>
> copyFile :: FilePath -> FilePath -> IO ()
> copyFile source dest = do
>     contents <- B.readFile source
>     B.writeFile dest contents

On crée notre propre fonction qui prend deux `FilePath` (rappelez-vous,
`FilePath` est un synonyme de `String`) et retourne une action I/O qui copie un
fichier sur l'autre en utilisant des chaînes d'octets. Dans la fonction `main`,
on récupère seulement les arguments et on appelle notre fonction avec ceux-ci
pour obtenir l'action I/O, qu'on exécute ensuite.

> $ runhaskell bytestringcopy.hs something.txt ../../something.txt

Remarquez qu'un programme qui n'utiliserait pas de chaîne d'octets paresseuses
ressemblerait exactement à celui-ci, à part le fait qu'on ait utilisé
`B.readFile` et `B.writeFile` au lieu de `readFile` et `writeFile`. Beaucoup de
fois, vous pouvez convertir un programme qui utilise des chaînes de caractères
normales en un programme qui utilise des chaînes d'octets en faisant les
imports nécessaires et en qualifiant les bonnes fonctions par le nom des
modules appropriés. Parfois, vous devez tout de même convertir certaines
fonctions que vous avez écrites pour qu'elle fonctionne sur des chaînes
d'octets, mais c'est assez facile.

Chaque fois que vous avez besoin de meilleures performances dans un programme
qui lit beaucoup de données, essayez les chaînes d'octets, il se peut que vous
obteniez de bons gains de performance sans trop d'efforts de votre part.
J'écris généralement mes programmes avec des chaînes de caractères, et je les
convertis en chaînes d'octets si les performances sont insatisfaisantes.

<h2 id="exceptions">
Exceptions
</h2>

<img src="img/timber.png" alt="timberr !!!" class="left"/>

Tous les langages ont des procédures, des fonctions et des bouts de code qui
peuvent échouer d'une certaine façon. C'est la vie. Différents langages ont
différentes manières de gérer ces erreurs. En C, on utilise généralement une
valeur anormale (comme `-1` ou un pointeur nul) pour indiquer que ce que la
fonction a retourné ne devrait pas être traité comme une valeur normale. Java
et C#, d'un autre côté, tendent à utiliser les exceptions pour gérer les
échecs. Quand une exception est levée, le flot de contrôle saute jusqu'à un
code qu'on a défini pour nettoyer un peu et possiblement lever une autre
exception de manière à ce qu'un autre gestionnaire d'exceptions s'occupe
d'autre chose.

Haskell a un très bon système de types. Les types de données algébriques
permettent d'utiliser des types comme `Maybe` ou `Either` et des valeurs de ces
types pour représenter des choses qui peuvent être présentes ou non. En C,
retourner, disons, `-1` en cas d'échec est un problème de convention. Cette
valeur n'est spéciale que pour nous humains, et si l'on ne fait pas attention,
on pourrait la traiter par erreur comme une valeur normale, et provoquer le
chaos et le désarroi dans notre code. Le système de types d'Haskell nous offre
une sûreté bien nécessaire sur cet aspect. Une fonction qui a pour type `a ->
Maybe b` indique clairement qu'elle peut produire un `b` enveloppé dans un
`Just` ou retourner `Nothing`. Le type est différent de `a -> b`, et si on
essaie de remplacer l'une par l'autre, le compilateur se plaindra.

Bien qu'il ait un système de types expressif qui supporte les échecs de
calculs, Haskell supporte quand même les exceptions, parce qu'elles sont plus
sensées dans un contexte d'I/O. Beaucoup de choses peuvent mal tourner quand on
traite avec le monde extérieur, car il est très imprévisible. Par exemple,
quand on ouvre un fichier, beaucoup de choses peuvent mal se passer. Le fichier
peut être verrouillé, ne pas être là, voire le disque dur lui-même peut ne pas
être là. Ainsi, il est pratique de sauter à une partie du code qui s'occupe de
gérer cela quand une telle erreur a lieu.

Ok, donc le code I/O (i.e. le code impur) peut lever des exceptions. C'est
sensé. Mais qu'en est-il du code pur ? Eh bien, il peut aussi lever des
exceptions. Pensez à `div` ou `head`. Elles ont respectivement pour type
`(Integral a) => a -> a -> a` et `[a] -> a`. Pas de `Maybe` ou d'`Either` dans
leur type de retour, et pourtant elles peuvent toute deux échouer ! `div` vous
explose au visage lorsque vous essayez de diviser par zéro et `head` pique une
crise de colère lorsqu'on lui donne une liste vide.

> ghci> 4 `div` 0
> *** Exception: divide by zero
> ghci> head []
> *** Exception: Prelude.head: empty list

<img src="img/police.png" alt="Arrête-toi là vermine criminelle ! Personne
n'enfreint la loi en ma présence ! Paie ton amende ou tu fileras en prison."
class="left"/>

Du code pur peut lancer des exceptions, mais elles ne peuvent être attrapées
que dans du code impur (dans un bloc *do* sous `main`). C'est parce que l'on ne
sait jamais quand (ou si) quelque chose sera évalué dans du code pur, puisqu'il
est paresseux et n'a pas d'ordre d'exécution spécifié, contrairement au code
d'entrée-sortie.

Plus tôt, on a parlé de passer le moins de temps possible de notre programme
dans les entrées-sorties. La logique de notre programme doit résider
principalement dans nos fonctions pures, parce que leur résultat ne dépend que
des paramètres avec lesquelles elles sont appelées. Quand vous manipulez des
fonctions pures, vous n'avez qu'à penser à ce qu'elles retournent, parce
qu'elles ne peuvent rien faire d'autre. Bien qu'un peu de logique dans les I/O
soit nécessaire (pour ouvrir des fichiers par exemple), elle devrait
préférablement être restreinte au minimum. Les fonctions pures sont paresseuses
par défaut, ce qui veut dire qu'on ne sait pas quand elles seront évaluées et
que cela ne doit pas importer. Cependant, dès que des fonctions pures se
mettent à lancer des exceptions, leur ordre d'évaluation devient important.
C'est pourquoi on ne peut attraper ces exceptions que dans la partie impure de
notre code. Et c'est mauvais, parce que l'on veut garder cette partie aussi
petite que possible. Cependant, si on n'attrape pas ces erreurs, notre
programme plante. La solution ? Ne pas mélanger les exceptions et le code pur.
Tirez profit du puissant système de types d'Haskell et utilisez des types comme
`Either` et `Maybe` pour représenter des résultats pouvant échouer.

C'est pourquoi nous n'allons regarder que les exceptions d'I/O pour l'instant.
Les exceptions d'I/O sont des exceptions causées par quelque chose se passant
mal lorsqu'on communique avec le monde extérieur dans une action I/O qui fait
partie de notre `main`. Par exemple, on peut tenter d'ouvrir un fichier, puit
s'apercevoir qu'il a été supprimé, ou quelque chose comme ça. Regardez ce
programme qui ouvre un fichier dont le nom lui est donné en argument et nous
dit combien de lignes le fichier contient.

> import System.Environment
> import System.IO
>
> main = do (fileName:_) <- getArgs
>           contents <- readFile fileName
>           putStrLn $ "The file has " ++ show (length (lines contents)) ++ " lines!"

Un programme très simple. On effectue l'action I/O `getArgs` et lie la première
chaîne de la liste retournée à `fileName`. Puis on appelle `contents` le
contenu du fichier qui porte ce nom. Finalement, on applique `lines` sur ce
contenu pour obtenir une liste de lignes, et on récupère la longueur de cette
liste et on la donne à `show` pour obtenir une représentation textuelle de ce
nombre. Cela fonctionne comme prévu, mais que se passe-t-il lorsqu'on donne le
nom d'un fichier inexistant ?

> $ runhaskell linecount.hs i_dont_exist.txt
> linecount.hs: i_dont_exist.txt: openFile: does not exist (No such file or directory)

Aha, on obtient une erreur de GHC, nous disant que le fichier n'existe pas.
Notre programme plante. Et si l'on voulait afficher un message plus joli quand
le fichier n'existe pas ? Un moyen de faire cela est de vérifier l'existence du
fichier à l'aide de `doesFileExist` de `System.Directory`.

> import System.Environment
> import System.IO
> import System.Directory
>
> main = do (fileName:_) <- getArgs
>           fileExists <- doesFileExist fileName
>           if fileExists
>               then do contents <- readFile fileName
>                       putStrLn $ "The file has " ++ show (length (lines contents)) ++ " lines!"
>               else do putStrLn "The file doesn't exist!"

On a fait `fileExists <- doesFileExist fileName` parce que `doesFileExist` a
pour type `doesFileExist :: FilePath -> IO Bool`, ce qui signifie qu'elle
retourne une action I/O qui a pour résultat une valeur booléenne nous indiquant
si le fichier existe. On ne peut pas utiliser simplement `doesFileExist` dans
une expression *if* directement.

Une autre solution ici serait d'utiliser des exceptions. C'est parfaitement
acceptable dans ce contexte. Un fichier inexistant est une exception qui est
levée par une I/O, donc l'attraper dans une I/O est propre et correct.

Pour gérer ceci en utilisant des exceptions, on va tirer parti de la fonction
`catch` de `System.IO.Error`. Son type est `catch :: IO a -> (IOError -> IO a)
-> IO a`. Elle prend deux paramètres. Le premier est une action I/O. Par
exemple, ça pourrait être une action I/O qui essaie d'ouvrir un fichier. Le
second est le gestionnaire d'exceptions. Si l'action I/O passée en premier
paramètre à `catch` lève une exception I/O, cette exception sera passée au
gestionnaire, qui décidera alors quoi faire. Le résultat final est une action
I/O qui se comportera soit comme son premier paramètre, ou bien exécutera le
gestionnaire en fonction de l'exception levée par la première action I/O.

<img src="img/puppy.png" alt="nom : sequidor" class="right"/>

Si vous êtes familier avec les blocs *try-catch* de langages comme Java ou
Python, la fonction `catch` est similaire. Le premier paramètre est la chose à
essayer, un peu comme ce qu'on met dans le bloc *try* dans d'autres langages
impératifs. Le second paramètre est le gestionnaire d'exceptions, un peu comme
la plupart des blocs *catch* qui reçoivent des exceptions que vous pouvez
examiner pour savoir ce qui s'est mal passé. Le gestionnaire est invoqué
lorsqu'une exception est levée.

Le gestionnaire prend une valeur de type `IOError`, qui est une valeur
signifiant que l'exception qui a eu lieu était liée à une I/O. Elle contient
aussi des informations sur le type de l'exception levée. La façon dont ce type
est implémenté dépend de l'implémentation du langage, donc on ne peut pas
inspecter les valeurs de type `IOError` par filtrage par motif, tout comme on
ne peut pas filtrer par motif les valeurs de type `IO something`. On peut tout
de même utiliser tout un tas de prédicats utiles pour savoir des choses à
propos de valeurs de type `IOError` comme nous le verrons dans une seconde.

Mettons notre nouvelle amie `catch` à l'essai !

> import System.Environment
> import System.IO
> import System.IO.Error
>
> main = toTry `catch` handler
>
> toTry :: IO ()
> toTry = do (fileName:_) <- getArgs
>            contents <- readFile fileName
>            putStrLn $ "The file has " ++ show (length (lines contents)) ++ " lines!"
>
> handler :: IOError -> IO ()
> handler e = putStrLn "Whoops, had some trouble!"

Tout d'abord, vous verrez qu'on a mis des apostrophes renversées autour de
`catch` pour l'utiliser de manière infixe, parce qu'elle prend deux paramètres.
L'utiliser de manière infixe la rend plus lisible. Donc, <code>toTry \`catch\`
handler</code> est la même chose que `catch toTry handler`, qui correspond bien
à son type. `toTry` est une action I/O qu'on essaie d'exécuter, et `handler`
est la fonction qui prend une `IOError` et retourne une action à exécuter en
cas d'exception.

Essayons&nbsp;:

> $ runhaskell count_lines.hs i_exist.txt
> The file has 3 lines!
>
> $ runhaskell count_lines.hs i_dont_exist.txt
> Whoops, had some trouble!

Dans le gestionnaire, nous n'avons pas vérifié de quel type d'`IOError` il
s'agissait. On a juste renvoyé `"Whoops, had some trouble!"` quelque que soit
le type d'erreur. Attraper tous les types d'erreur dans un seul gestionnaire
est une mauvaise pratique en Haskell tout comme dans la plupart des autres
langages. Et si une exception arrivait que l'on ne désirait pas attraper, comme
une interruption du programme par l'utilisateur ? C'est pour cela qu'on va
faire comme dans la plupart des autres langages&nbsp;: on va vérifier de quel
type d'exception il s'agit. Si c'est celui qu'on attendait, on la traite.
Sinon, on la lève à nouveau dans la nature. Modifions notre programme pour
n'attraper que les exceptions liées à l'inexistence du fichier.

> import System.Environment
> import System.IO
> import System.IO.Error
>
> main = toTry `catch` handler
>
> toTry :: IO ()
> toTry = do (fileName:_) <- getArgs
>            contents <- readFile fileName
>            putStrLn $ "The file has " ++ show (length (lines contents)) ++ " lines!"
>
> handler :: IOError -> IO ()
> handler e
>     | isDoesNotExistError e = putStrLn "The file doesn't exist!"
>     | otherwise = ioError e

Tout reste pareil à part le gestionnaire, qu'on a modifié pour n'attraper qu'un
certain groupe d'exceptions I/O. Ici, on a utilisé deux nouvelles fonctions de
`System.IO.Error` - `isDoesNotExistError` et `ioError`. `isDoesNotExistError`
est un prédicat sur les `IOError`, ce qui signifie que c'est une fonction
prenant une `IOError` et retournant `True` ou `False`, ayant donc pour type
`isDoesNotExistError :: IOError -> Bool`. On utilise cette fonction sur
l'exception que notre gestionnaire reçoit pour savoir si c'est une erreur
causée par l'inexistence du fichier. On utilise la syntaxe des
[gardes](syntaxe-des-fonctions#gardes-gardes) ici, mais on aurait aussi pu
utiliser un *if else*. Si ce n'était pas causé par un fichier inexistant, on
lève à nouveau l'exception passée au gestionnaire à l'aide de la fonction
`ioError`. Elle a pour type `ioError :: IOError -> IO a`, donc elle prend une
`IOError` et produit une action I/O qui va lever cette exception. L'action I/O
a pour type `IO a`, parce qu'elle ne retourne jamais de résultat, donc elle
peut se faire passer pour une `IO anything`.

Donc, si l'exception levée dans l'action I/O `toTry` qu'on a collée avec un
bloc *do* n'est pas causée par l'inexistence du fichier, <code>toTry \`catch\`
handler</code> va attraper cette exception et la lever à nouveau. Plutôt cool,
hein ?

Il y a plusieurs prédicats qui agissent sur des `IOError`, et lorsqu'une garde
n'est pas évaluée comme `True`, l'évaluation passe à la prochaine garde. Les
prédicats sur les `IOError` sont&nbsp;:

* `isAlreadyExistsError`
* `isDoesNotExistError`
* `isAlreadyInUseError`
* `isFullError`
* `isEOFError`
* `isIllegalOperation`
* `isPermissionError`
* `isUserError`

La plupart d'entre eux sont évidents. `isUserError` s'évalue à `True` quand on
utilise la fonction `userError` pour lever l'exception, qui sert à utiliser nos
propres exceptions en les accompagnant d'une chaîne de caractères. Par exemple,
vous pouvez faire `ioError $ userError "remote computer unplugged!"`, bien
qu'il soit préférable d'utiliser des types comme `Either` et `Maybe` pour
exprimer des échecs plutôt que de lancer vous-même des exceptions avec
`userError`.

Vous pourriez ainsi avoir un gestionnaire de la sorte&nbsp;:

> handler :: IOError -> IO ()
> handler e
>     | isDoesNotExistError e = putStrLn "The file doesn't exist!"
>     | isFullError e = freeSomeSpace
>     | isIllegalOperation e = notifyCops
>     | otherwise = ioError e

Où `notifyCops` et `freeSomeSpace` sont des actions I/O que vous définissez.
Soyez certain de lever à nouveau les exceptions si elles ne correspondent pas à
vos critères, sinon votre programme échouera silencieusement là où il ne
devrait pas.

`System.IO.Error` exporte aussi des fonctions qui nous premettent de demander à
nos exceptions certains de leurs attributs, comme la poignée de fichier qui a
causé l'erreur, ou le nom du fichier. Elles commencent par `ioe` et vous pouvez
trouver la [liste
complète](http://www.haskell.org/ghc/docs/6.10.1/html/libraries/base/System-IO-Error.html#3)
dans la documentation. Mettons qu'on veuille afficher le nom du fichier
responsable de l'erreur. On ne peut pas afficher le `fileName` qu'on a reçu de
`getArgs`, parce que seule l'`IOError` est passée au gestionnaire, et ce
dernier ne connaît rien d'autre. Une fonction ne dépend que des paramètres avec
lesquels elle a été appelée. C'est pourquoi on peut utiliser la fonction
`ioeGetFileName`, qui a pour type `ioeGetFileName :: IOError -> Maybe
FilePath`. Elle prend une `IOError` en paramètre et retourne éventuellement un
`FilePath` (qui est un synonyme de `String`, souvenez-vous en). En gros, elle
extrait le chemin du fichier de l'`IOError`, si elle le peut. Modifions notre
programme pour afficher le chemin du fichier responsable de l'exception.

> import System.Environment
> import System.IO
> import System.IO.Error
>
> main = toTry `catch` handler
>
> toTry :: IO ()
> toTry = do (fileName:_) <- getArgs
>            contents <- readFile fileName
>            putStrLn $ "The file has " ++ show (length (lines contents)) ++ " lines!"
>
> handler :: IOError -> IO ()
> handler e
>     | isDoesNotExistError e =
>         case ioeGetFileName e of Just path -> putStrLn $ "Whoops! File does not exist at: " ++ path
>                                  Nothing -> putStrLn "Whoops! File does not exist at unknown location!"
>     | otherwise = ioError e

Dans la garde où `isDoesNotExistError` est `True`, on a utilisé une expression
*case* pour appeler `ioeGetFileName` avec `e`, puis on a filtré par motif
contre la valeur `Maybe` retournée. Utiliser une expression *case* se fait
généralement pour filtrer par motif sur quelque chose sans introduire une
nouvelle fonction.

Vous n'avez pas à utiliser un unique gestionnaire pour attraper (i.e. `catch`)
toutes les exceptions de la partie I/O de votre code. Vous pouvez simplement
protéger certaines parties de votre code avec `catch` ou vous pouvez couvrir
plusieurs parties avec `catch` et utiliser différents gestionnaires pour
chacune, ainsi&nbsp;:

> main = do toTry `catch` handler1
>           thenTryThis `catch` handler2
>           launchRockets

Ici, `toTry` utilise le gestionnaire `handler1` et `thenTryThis` utilise le
gestionnaire `handler2`. `launchRockets` n'est pas un paramètre de `catch`,
donc toute exception qu'elle pourra lancer plantera probablement votre
programme, à moins que `launchRockets` n'utilise un `catch` en interne pour
gérer ses propres exceptions. Bien sûr, `toTry`, `thenTryThis` et
`launchRockets` sont des actions I/O qui ont été collées ensemble avec la
notation *do* et, hypothétiquement définies quelque part ailleurs. C'est un peu
similaire aux blocs *try-catch* des autres langages, où l'on peut entourer
notre programme entier d'un simple *try-catch*, ou bien utiliser une approche
plus fine et utiliser différents *try-catch* sur différentes parties du code
pour contrôler le type d'erreur qui peut avoir lieu à chaque endroit.

Maintenant, vous savez gérer les exceptions I/O ! Lever des exceptions depuis
un code pur n'a pas encore été couvert, principalement parce que, comme je l'ai
déjà dit, Haskell offre de bien meilleurs façons d'indiquer des erreurs, plutôt
que s'en remettre aux I/O pour les attraper. Même en collant des actions I/O
les unes aux autres, je préfère que leur type soit `IO (Either a b)`,
c'est-à-dire des actions I/O normales mais dont le résultat peut être `Left a`
ou `Right b` lorsqu'elles sont exécutées.

<div class="prev-toc-next">
<ul>
<li style="text-align:left">
<a href="creer-nos-propres-types-et-classes-de-types" class="prevlink">Créer nos propres types et classes de types</a>
</li>
<li style="text-align:center">
[Table des matières](chapitres)
</li>
<li style="text-align:right">
<a href="resoudre-des-problemes-fonctionnellement" class="nextlink">Résoudre des problèmes fonctionnellement</a>
</li>
</ul>
</div>
