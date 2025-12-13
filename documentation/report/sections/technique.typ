= Technique

Cette section décrit les choix techniques et l'architecture mise en place pour le développement de l'application PetSim, un animal de compagnie virtuel interactif fonctionnant sur Android et iOS.

== Choix architecturaux

=== BLoC (Business Logic Component)

L'application utilise *BLoC* via la librairie `flutter_bloc` pour la gestion d'état. Ce pattern sépare clairement la logique métier de l'interface utilisateur :

- *HomeBloc* : Gère l'état principal du Tamagotchi (statistiques, événements, capteurs), on y trouve la majorité de la logique métier
- *GameBloc* : Gère la logique du mini-jeu de devinette de nombres

Le BLoC réagit à des événements (`Feed`, `Play`, `Sleep`, `LiceAttack`, etc.) et émet des états immutables grâce à la librairie `equatable`.

=== SharedPreferences

La classe `TamagotchiRepository` encapsule la persistance des données via `SharedPreferences`. Le Tamagotchi est sérialisé en JSON pour le stockage local, permettant la sauvegarde automatique et la restauration de l'état entre les sessions.

L'utilisation de `SharedPreferences` garantit une solution légère et rapide pour les données non relationnelles de l'application. Une base de données plus complexe (ex: SQLite) n'était pas nécessaire pour ce cas d'usage.

=== Modèle de données immutable

Le modèle `Tamagotchi` est conçu avec des propriétés `final` et une méthode `copyWith()` pour garantir l'immutabilité. Les statistiques gérées incluent :
- Faim, énergie, bonheur, propreté (0-100)
- Compteur de crottes et de promenades
- État visuel (idle, sleeping, eating, crying, liceAttack, etc.)

== Logique du jeu

Le Tamagotchi possède quatre statistiques principales qui évoluent au fil du temps et des interactions : la faim, l'énergie, le bonheur et l'hygiène. L'objectif du joueur est de maintenir ces statistiques à un niveau acceptable pour garder son compagnon virtuel en vie et heureux.

=== Écran principal et statistiques

#figure(
  image("../images/idle.jpg", width: 40%),
  caption: [Écran principal avec les quatre barres de statistiques et le Tamagotchi en état idle],
)

L'écran principal affiche les quatre statistiques sous forme de barres de progression colorées. Le Tamagotchi est animé au centre de l'écran et réagit visuellement à son état actuel.

Le joueur peut interagir avec son Tamagotchi de plusieurs manières :

==== Nourrir

#figure(
  image("../images/eating.jpg", width: 40%),
  caption: [Animation de nourrissage du Tamagotchi],
)

En appuyant sur le bouton de nourriture (en orange avec un icône de couteau et cuillère), le joueur augmente la jauge de faim du Tamagotchi. Une animation de repas est jouée pendant l'action.

==== Caresser

#figure(
  image("../images/touch.jpg", width: 40%),
  caption: [Détection du toucher pour caresser le Tamagotchi],
)

Le joueur peut caresser son Tamagotchi en frottant l'écran directement sur l'animal. Cette interaction augmente légèrement le bonheur.

==== Dormir

#figure(
  image("../images/sleeping.jpg", width: 40%),
  caption: [Le Tamagotchi en train de dormir],
)

Le sommeil permet de récupérer de l'énergie. Le Tamagotchi peut s'endormir automatiquement lorsque le capteur de lumière détecte l'obscurité.

==== Apparition de crottes

#figure(
  image("../images/poop.jpg", width: 40%),
  caption: [Des crottes apparaissent à l'écran],
)

Des crottes apparaissent aléatoirement et affectent la propreté du Tamagotchi.

==== Mode nettoyage

#figure(
  grid(
    columns: 2,
    gutter: 10pt,
    image("../images/cleaning1.jpg", width: 100%),
    image("../images/cleaning2.jpg", width: 100%),
  ),
  caption: [Processus de nettoyage : mode nettoyage et lavage du Tamagotchi],
)

Pour nettoyer les crottes, le joueur entre en mode nettoyage (bouton bleu avec un icône balai) puis frotte les zones sales pour les éliminer. Lorsque qu'il n'y a pas de crottes à l'écran, le bouton de nettoyage lance un animation ou le Tamagotchi se lave et regagne de l'hygiène.

==== Attaque de poux

#figure(
  image("../images/lice.jpg", width: 40%),
  caption: [Le Tamagotchi est attaqué par des poux],
)

Les poux peuvent attaquer aléatoirement le Tamagotchi. Pour les éliminer, le joueur doit secouer physiquement son téléphone (détection via l'accéléromètre). C'est un événement haute priorité qui interrompt les autres actions et est bloquant.

==== Mort du Tamagotchi

#figure(
  image("../images/dead.jpg", width: 40%),
  caption: [Écran de mort du Tamagotchi],
)

Si toutes les statistiques atteignent zéro, le Tamagotchi meurt. Le joueur peut alors recommencer avec un nouveau compagnon.

=== Création du Tamagotchi

#figure(
  image("../images/naming.jpg", width: 40%),
  caption: [Écran de création et nommage du Tamagotchi],
)

Au premier lancement ou lors de l'adoption d'un nouveau compagnon, le joueur peut donner un nom à son Tamagotchi.

=== Mini-jeu

#figure(
  grid(
    columns: 2,
    gutter: 10pt,
    image("../images/game_instructions.jpg", width: 100%),
    image("../images/game.jpg", width: 100%),
  ),
  caption: [Mini-jeu de devinette de nombres : instructions et gameplay],
)

Un mini-jeu de devinette de nombres est accessible depuis la navigation en bas de l'écran. Le joueur doit deviner un nombre entre 1 et 100 en un nombre limité d'essais. Gagner augmente le bonheur du Tamagotchi.

== Points clés

=== Intégration des capteurs natifs

L'application exploite plusieurs capteurs du téléphone pour une expérience immersive :

- *Accéléromètre* (`sensors_plus`) : Détection des secousses pour éliminer les poux. Un algorithme de fenêtre temporelle compte les secousses dépassant un seuil configurable.
- *Capteur de lumière* (`ambient_light`) : Détection de l'obscurité pour déclencher le sommeil automatique du Tamagotchi.
- *Podomètre* (`pedometer`) : Suivi du nombre de pas effectués par l'utilisateur. Chaque tranche de 1000 pas complétée récompense le Tamagotchi avec un gain d'énergie (+10) et de bonheur (+15). Le but est de simuler une réelle promenade avec son compagnon virtuel.

Des permissions utilisateur sont demandées au démarrage pour accéder aux capteurs nécessaires.

=== Système d'animations Lottie

Les animations sont gérées via la librairie `lottie` avec un système de cache personnalisé (`LottiePreloader`) :
- Maximum 4 animations en mémoire simultanément
- Préchargement de l'animation idle au démarrage
- Chargement paresseux des autres animations à la demande

=== Machine à états visuels

L'enum `VisualState` définit les différents états visuels avec un système de priorité configurable :
- Chaque état possède une ou plusieurs animations (init + cycle)
- Les états haute priorité (ex: `liceAttack`) peuvent interrompre les états basse priorité
- Configuration centralisée dans `TamagotchiConfig`

=== Système de tick et décroissance

Un `Timer` périodique (1 seconde par défaut pour le développement) déclenche la décroissance des statistiques :
- Calcul des ticks écoulés lors de la réouverture de l'application
- Événements aléatoires (crottes, attaque de poux) basés sur des probabilités configurables

=== Événements et priorités

Les événements utilisateur (nourrir, jouer, dormir) et les événements automatiques (mort, poux) sont gérés avec des priorités pour éviter les conflits :

#figure(
  image("../images/priority.svg", width: 80%),
  caption: [Hiérarchie des priorités des états visuels du Tamagotchi],
)

Un événement peut prendre le contrôle uniquement si sa priorité est supérieure à l'événement en cours. Cela garantit une expérience utilisateur fluide et cohérente.

=== Équilibrage et configuration

Toutes les constantes de l'application (probabilités, seuils, gains, durées, priorités, etc.) sont centralisées dans la classe `TamagotchiConfig`. Cela facilite l'ajustement de l'équilibrage du jeu sans modifier la logique métier.

Actuellement, les valeurs choisies sont basées pour le développement (tout est très rapide pour que l'on puisse rapidement tester toutes les fonctionnalités). Un équilibrage est nécessaire pour une version jouable en production.

=== Internationalisation

L'application supporte l'internationalisation via la bibliothèque `slang`. Actuellement, seules les langues française et anglaise sont implémentées, avec la possibilité d'ajouter facilement d'autres langues à l'avenir.

== Choix technologiques

Pour le développement de l'application, nous avons uttilisé une variété de technologies et de bibliothèques Flutter/Dart afin de répondre aux besoins fonctionnels et techniques du projet.

Pour réaliser les choix techniques, nous avons pris en compte plusieurs critères :
- **Compatibilité cross-platform** : Assurer le bon fonctionnement sur Android et iOS
- **Facilité d'intégration** : Utiliser des bibliothèques bien documentées et maintenues (dernier commit récent)
- **Communauté et support** : Préférer les solutions populaires avec une communauté active, si possible avec la mention "Flutter Favorite" et sinon avec un bon nombres de téléchargements sur pub.dev

Nous allons maintenant détailler les principales technologies utilisées.

=== Lottie

Lottie est une bibliothèque open-source développée par Airbnb qui permet d'afficher des animations vectorielles légères et de haute qualité dans les applications mobiles et web à l'aide de fichiers JSON.

Nous avons choisi Lottie pour intégrer les animations de notre Tamagotchi principalement car les animations Lottie sont plus légères que les GIFs ou vidéos, ce qui réduit la taille de l'application et améliore les performances.

De plus, la bibliothèque Lottie pour Flutter offre une intégration simple et complète, facilitant l'ajout et la gestion des animations dans l'application.

Elle a également une assez grande communauté et est bien maintenue, avec de nombreuses ressources disponibles en ligne.

=== Sensors Plus

Sensors Plus est une bibliothèque Flutter qui fournit une interface simple pour accéder aux capteurs matériels des appareils mobiles, tels que l'accéléromètre, le gyroscope, le magnétomètre, etc.

Nous avons choisi Sensors Plus pour accéder à l'accéléromètre du téléphone afin de détecter les secousses effectuées par l'utilisateur pour éliminer les poux du Tamagotchi. 

Cette bibliothèque est bien documentée, facile à utiliser et largement adoptée dans la communauté Flutter, ce qui garantit un bon support et une maintenance continue. De plus, elle bénéficie de la mention "Flutter Favorite" sur pub.dev, attestant de sa qualité et de sa fiabilité.

=== Ambient Light

La bibliothèque Ambient Light pour Flutter permet d'accéder au capteur de lumière ambiante des appareils mobiles.

Nous avons choisi cette bibliothèque pour détecter les conditions de luminosité ambiante et ainsi déclencher le sommeil automatique du Tamagotchi lorsque l'environnement devient sombre.

Cette bibliothque est la seule disponible (de ce que nous avons pu trouver) pour Flutter offrant cette fonctionnalité pour Android et iOS (la plupart ne le font que pour Android). Elle est également simple à intégrer et à utiliser, avec une documentation adéquate.

=== Health

La bibliothèque Health pour Flutter fournit un accès unifié aux données de santé des appareils mobiles via Apple HealthKit (iOS) et Google Health Connect (Android), incluant le suivi des pas.

Nous avons intégré cette bibliothèque pour créer une mécanique de promenade virtuelle avec le Tamagotchi. Le système fonctionne de manière passive en arrière-plan : chaque fois que l'utilisateur complète une tranche de 1000 pas (configurable via `TamagotchiConfig.stepsPerWalk`), le Tamagotchi reçoit automatiquement un bonus d'énergie (+10) et de bonheur (+15). Cette fonctionnalité encourage l'activité physique réelle de l'utilisateur tout en enrichissant l'expérience de jeu.

D'un point de vue technique, le `HomeBloc` écoute le flux de données du podomètre via l'événement `UpdateSteps`, qui met à jour les champs `totalSteps` et `lastStepCount` du modèle Tamagotchi. Lorsque la différence entre le nombre de pas total et le dernier palier atteint dépasse 1000, les récompenses sont automatiquement attribuées et le compteur `lastStepCount` est incrémenté.

Cette bibliothèque bénéficie de la mention "Flutter Favorite" sur pub.dev, attestant de sa qualité et de sa fiabilité. Elle offre un bon support sur Android et iOS, bien qu'elle nécessite des permissions spécifiques pour accéder aux données de santé sur chaque plateforme.

=== Slang

Slang est une bibliothèque Flutter dédiée à l'internationalisation (i18n) et à la localisation (l10n) des applications mobiles.

Nous avons choisi Slang pour gérer l'internationalisation de notre application PetSim Flutter, car elle offre une approche moderne et flexible pour la gestion des traductions et des ressources linguistiques. Slang permet de structurer facilement les fichiers de traduction (au format JSON), de gérer les pluriels et les formats spécifiques à chaque langue. De plus, elle est bien maintenue et dispose d'une communauté active, ce qui garantit un bon support et des mises à jour régulières.

Sa facilité d'utilisation et son guide de démarrage clair en font un choix idéal pour intégrer l'internationalisation dans notre application.



== Problèmes rencontrés

=== Génération des animations Lottie

Une des première étapes du projet a été de créer les animations Lottie pour les différents états du Tamagotchi. 

Pour cela nous avons utilisé différents outils d'intelligence artificielle générative, principalement Runway. Les animations ont été créées en plusieurs étapes :
1. Génération des animations vidéo avec Runway en utilisant des prompts textuels décrivant les actions du Tamagotchi (manger, dormir, jouer, etc.)
2. Conversion des vidéos en animations Lottie via un outil de conversion en ligne
3. Suppression du fond blanc des animations Lottie avec à l'aide d'un script python
4. Optimisation des fichiers Lottie pour réduire la taille et améliorer les performances

Ce processus fut long et fastidieux, nécessitant parfois beaucoup d'itérations pour obtenir des animations cohérentes de la part de Runway.

Des astuces ont été testées pour essayé d'améliorer la qualité des animations générées, comme l'utilisation de ChatGPT pour affiner les prompts textuels.

La méthodologie complète et les scripts utilisés sont disponibles dans le répertoire du projet sous `assets_generation/`.

=== Gestion de la mémoire avec Lottie

Les animations Lottie, bien que légères en taille de fichier, peuvent consommer beaucoup de mémoire une fois chargées. Nous avons voulu initialement préchargé l'intégralité des animations afin de ne pas avoir de latence lors de leur affichage.

Le préchargement de toutes les animations au démarrage causait a pu causé des overflows mémoire. Nous avons donc dû faire partiellement marche arrière en implémentant un système de cache limitant le nombre d'animations en mémoire simultanément et donc charger certaines animations à la demande. Cela peut toutefois introduire une légère latence lors du premier affichage d'une animation non préchargée.

=== Compatibilité cross-platform

Nous nous sommes heurtés à plusieurs différences de comportement entre Android et iOS, notamment au niveau des capteurs natifs.

Par exemple, pour l'accéléromètre, Android ne nécessite pas de permissions supplémentaires, tandis que iOS demande l'autorisation explicite de l'utilisateur pour accéder aux données de mouvement. De plus, la documentation de la librairie `sensors_plus` ne précisait pas clairement l'entiereté des permissions nécessaires sur iOS, ce qui a causé des erreurs lors des tests initiaux.

Une autre différence est le capteur de lumière ambiante, il n'existe pas sur iOS, nécessitant l'utilisation de la caméra frontale comme alternative. Cela demande des permissions supplémentaires et peut impacter la vie privée de l'utilisateur. De plus, le seuil de luminosité doit être ajusté différemment entre les deux plateformes pour un comportement cohérent.

=== Compréhension de BLoC et choix d'architecture

La mise en place du pattern BLoC a nécessité une courbe d'apprentissage, notamment pour structurer les événements et états de manière cohérente. La gestion de la logique métier dans un seul bloc (`HomeBloc`) a conduit à un fichier volumineux et difficile à maintenir.

Avant cela nous avions envisagé et essayé de rajouter l'utilisation de classes services pour découper la logique métier, mais nous avons finalement préféré garder une architecture simple avec un seul BLoC principal.