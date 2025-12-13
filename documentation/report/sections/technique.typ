= Technique

Cette section décrit les choix techniques et l'architecture mise en place pour le développement de l'application Tamagotchi Flutter, un animal de compagnie virtuel interactif fonctionnant sur Android et iOS.

== Choix architecturaux

=== BLoC (Business Logic Component)

L'application utilise *BLoC* via la librairie `flutter_bloc` pour la gestion d'état. Ce pattern sépare clairement la logique métier de l'interface utilisateur :

- *HomeBloc* : Gère l'état principal du Tamagotchi (statistiques, événements, capteurs), on y trouve la majorité de la logique métier
- *GameBloc* : Gère la logique du mini-jeu de devinette de nombres

Le BLoC réagit à des événements (`Feed`, `Play`, `Sleep`, `LiceAttack`, etc.) et émet des états immutables grâce à la librairie `equatable`.

=== SharedPreferences

La classe `TamagotchiRepository` encapsule la persistance des données via `SharedPreferences`. Le Tamagotchi est sérialisé en JSON pour le stockage local, permettant la sauvegarde automatique et la restauration de l'état entre les sessions.

L'utilisation de `SharedPreferences` garantit une solution légère et rapide pour les données non relationnelles de l'application. Une base de données plus complexe (ex: SQLite) n'était pas nécessaire pour ce cas d'usage.

=== MVVM (Model-View-ViewModel) ou Repository ???

TODO

L'architecture suit le pattern MVVM où :
- *Model* : Représenté par la classe `Tamagotchi` et ses propriétés
- *View* : Les widgets Flutter affichant l'interface utilisateur
- *ViewModel* : Les BLoC gérant la logique métier et l'état de l'application.

=== Modèle de données immutable

Le modèle `Tamagotchi` est conçu avec des propriétés `final` et une méthode `copyWith()` pour garantir l'immutabilité. Les statistiques gérées incluent :
- Faim, énergie, bonheur, propreté (0-100)
- Compteur de crottes et de promenades
- État visuel (idle, sleeping, eating, crying, liceAttack, etc.)

== Logique du jeu

TODO ajouter des screen et explqiuer les interactions

== Points clés

=== Intégration des capteurs natifs

L'application exploite plusieurs capteurs du téléphone pour une expérience immersive :

- *Accéléromètre* (`sensors_plus`) : Détection des secousses pour éliminer les poux. Un algorithme de fenêtre temporelle compte les secousses dépassant un seuil configurable.
- *Capteur de lumière* (`ambient_light`) : Détection de l'obscurité pour déclencher le sommeil automatique du Tamagotchi.
- *Podomètre* ??? TODO

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

TODO ajouter image priority.svg

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

TODO

=== Sensors Plus

TODO

=== Ambient Light

TODO

=== Slang

TODO

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

La méthodologie complète et les scripts utilisés sont disponibles ... TODO

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

== Conclusion technique

L'architecture choisie (BLoC + ???) offre une base solide et testable pour l'application. La séparation des responsabilités permet d'ajouter facilement de nouvelles fonctionnalités (achievements, mini-jeux) sans impacter le cœur de l'application. L'utilisation de capteurs natifs enrichit l'expérience utilisateur tout en présentant des défis d'intégration cross-platform qui ont été résolus par des abstractions appropriées.

== Auto-critique

*Points positifs :*
- Architecture modulaire et extensible
- Configuration centralisée facilitant les ajustements
- Gestion efficace de la mémoire pour les animations

*Axes d'amélioration :*
- Le fichier `home_bloc.dart` (640+ lignes) mériterait d'être découpé en blocs plus spécialisés
- L'absence de tests unitaires pour la logique métier
- Le système d'achievements reste à implémenter complètement
- La gestion des erreurs des capteurs pourrait être plus robuste avec des fallbacks utilisateur