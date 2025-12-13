= Futur du travail

== Limites de la solution et implémentation

Malgré les fonctionnalités implémentées, plusieurs aspects restent à vhanger, améliorer ou à compléter dans le futur.

=== Création des animations

Les animations sont longues à créer malgré l'utilisation de Runway pour la génération initiale et n'utilise pas le vrai point fort de Lottie qui est l'animation vectorielle. Notre méthode actuelle génère des animations comme une suite d'images matricielle, ce qui augmente la taille de l'application et la consommation mémoire lors de l'affichage des animations.

Idéalement, il faudrait créer des animations vectorielles directement dans un outil comme Adobe After Effects avec le plugin Lottie. Cela permettrait d'avoir des animations plus légères, plus fluides et plus facilement modifiables. Cependant, cela nécessite des compétences en animation que nous ne possédons pas actuellement.

=== Découpage du code

Le fichier `home_bloc.dart` est actuellement très volumineux (plus de 700 lignes) et gère de nombreuses responsabilités. Pour améliorer la maintenabilité et la lisibilité du code, il serait pertinent de le découper en plusieurs blocs plus spécialisés, chacun gérant une partie spécifique de la logique métier (par exemple, un bloc pour la gestion des statistiques, un autre pour les événements automatiques, etc.).

== Nouvelles fonctionnalités

=== Achievements

Le système d'achievements n'est pas encore implémenté mais son emplacement dans l'interface est déjà prévu. Ajouter des achievements permettrait d'augmenter l'engagement des utilisateurs en leur offrant des objectifs à atteindre. Les achievements pourraient récompenser des actions comme "Nourrir le Tamagotchi 10 fois" ou "Gagner 5 mini-jeux". Ils seraient affichés dans une section dédiée avec des icônes et des descriptions.

=== Ajouts de nouveaux états

Afin de rendre le Tamagotchi plus vivant et réaliste, de nouveaux états pourraient être ajoutés, tels que : heureux, triste, excité, affamé, etc. Chaque état pourrait avoir des animations qui lui sont propres seraient déclenchées en fonction de l'évolution des caractéristiques du Tamagotchi (par exemple, un Tamagotchi avec un niveau de bonheur élevé pourrait afficher une animation de danse). Certaines animations ont déjà été créées mais ne sont pas encore intégrées dans la logique actuelle.

== Ajout de tests

L'absence de tests unitaires pour la logique métier est une limitation actuelle. Ajouter des tests permettrait d'assurer la stabilité et la fiabilité de l'application lors de futures modifications. Les tests pourraient couvrir des aspects comme la gestion des statistiques du Tamagotchi, les événements automatiques et les interactions utilisateur.