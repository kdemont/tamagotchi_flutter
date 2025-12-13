= Annexes
== Cahier des charges original
Le document est à trouver dans le dossier de rendu du projet.
== Planification
=== Initiale

#table(
  columns: (auto, 1fr),
  align: (left, left),
  stroke: 0.5pt,
  [*Semaine*], [*Tâches*],
  [Semaine 44 - 22.10.2025 au 02.11.2025], [Initialisation du projet, structure de dossier selon le pattern, l'architecture, recherche d'assets],
  [Semaine 45 - 03.11.2025 au 09.11.2025], [Mise en place du modèle],
  [Semaine 46 - 10.11.2025 au 16.11.2025], [Développement des fonctionnalités principales],
  [Semaine 47 - 17.11.2025 au 23.11.2025], [Développement des fonctionnalités secondaires],
  [Semaine 48 - 24.11.2025 au 30.11.2025], [Finalisation du code et factorisation],
  [Semaine 49 - 01.12.2025 au 07.12.2025], [Finalisation du rapport / Tests],
  [11 décembre 2025], [Rendu du projet],
  [15 décembre 2025], [Présentation du projet],
)
=== Actualisée

#table(
  columns: (auto, 1fr),
  align: (left, left),
  stroke: 0.5pt,
  [*Date*], [*Tâches réalisées*],
  [18 novembre 2025], [
    - Initialisation du projet Flutter
    - Structure BLoC mise en place
    - Animations de base (happy bouncing)
    - Génération des assets (avec RunwayML)
  ],
  [24 novembre 2025], [
    - Ajout du timer dans le BLoC
    - Gestion "Time-based events"
  ],
  [25 novembre - 1 décembre 2025], [
    - Intégration des capteurs (accéléromètre)
    - Attaque de puces (lice attack)
    - Correction iOS pour l'accéléromètre
    - Rédaction du rapport
  ],
  [7 décembre 2025], [
    - Préchargement des animations (cache)
    - Fonctionnalité de sommeil avec capteur de lumière
    - Rédaction du rapport
  ],
  [8 décembre 2025], [
    - Structure BLoC pour le jeu
    - Interface du jeu (rules, won, lost views)
    - Gestion des cacas
    - Animation de sommeil
    - Rédaction du rapport
  ],
  [11 décembre 2025], [
    - Gestion du capteur de pas
    - Animation de caresse (petting)
    - Assets pour le jeu
    - Fichier de configuration global
    - Corrections diverses (overflow, nettoyage cacas, cache mémoire)
    - Rédaction du rapport
  ],
  [12 décembre 2025], [
    - Internationalisation (i18n)
    - Demande de permissions (android)
    - Animation de nourrissage
    - Rédaction du rapport
    - Traductions
  ],
  [13 décembre 2025], [
    - Passage à HealthKit et Health Connect pour le podomètre
    - Implémentation du début et fin de vie du Tamagotchi
    - Modification des priorités des événements
    - Rédaction du rapport
  ],
)

== Liste des bugs connus
- Le capteur de luminosité permettant de déclancher le sommeil du Tamagotchi a une sensibilité différente selon  les appareils. Nous avons testé sur nos deux appareils personnels (iOS et Android) et le seuil de luminosité pour déclancher le sommeil était drastiquement différent.
