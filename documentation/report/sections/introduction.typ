= Introduction

== Contexte du projet

Ce projet s'inscrit dans le cadre du cours AddMoApp et a pour objectif de développer une application mobile native en utilisant le framework Flutter. Le projet vise à mettre en pratique les concepts appris en classe, notamment la gestion d'état, l'architecture d'application, et l'intégration de capteurs natifs.

C'était également l'occasion de mettre en place des bonnes pratiques d'au niveau de l'expérience utilisateur ainsi que de faire évaluer le prototype par des utilisateurs réels.

L'application développée, nommée PetSim, s'inspire du célèbre phénomène Tamagotchi des années 1990-2000. Il s'agit d'un simulateur d'animal de compagnie virtuel où l'utilisateur doit prendre soin de son compagnon numérique en répondant à ses besoins quotidiens : nourriture, jeu, hygiène et santé.

== Rappel des fonctionnalités à implémenter

=== Cycle de vie et caractéristiques dynamiques

Le Tamagotchi possède quatre caractéristiques vitales représentées sous forme de barres de progression :

- *Faim* : diminue avec le temps et augmente lorsque l'animal est nourri
- *Bonheur* : reflète le bien-être général, influencé par les interactions et les mini-jeux
- *Énergie* : décroît au fil du temps et lors d'activités, se régénère pendant le sommeil
- *Propreté* : diminue progressivement et peut être restaurée par le nettoyage

Une cinquième caractéristique, l'*âge*, augmente continuellement et représente la longévité du Tamagotchi. Cette valeur constitue le score final affiché lors de sa mort.

=== Interactions de l'utilisateur

L'utilisateur peut interagir directement avec son compagnon via plusieurs mécanismes :

- *Caresser* le Tamagotchi en le frottant avec le doigt pour augmenter son bonheur
- *Laver* l'animal avec le même geste pour améliorer sa propreté
- *Nourrir* via un bouton dédié accompagné d'une animation
- *Jouer* via un mini-jeu de devinette de nombre avec système chaud/froid

=== Fonctionnalités context-aware utilisant les capteurs

*Accéléromètre* : Détecte un mouvement de secousse pour éliminer les poux lors d'une attaque de parasites déclenchée par une propreté trop faible.

*Capteur de luminosité (caméra)* : Le Tamagotchi s'endort automatiquement lorsqu'il fait sombre, régénérant ainsi son énergie.

*Suivi d'activité physique* : Les déplacements de l'utilisateur, mesurés via HealthKit (iOS) et Health Connect (Android), influencent positivement le bonheur et négativement la propreté.

=== Événements dynamiques

- *Mort du Tamagotchi* : survient lorsque toutes les caractéristiques atteignent leur minimum
- *Attaque de poux* : événement déclenché par une propreté insuffisante

=== Système de succès

Un système d'achievements permet de suivre la progression de l'utilisateur à travers différents objectifs (nourrir X fois, atteindre un certain âge, etc.)
