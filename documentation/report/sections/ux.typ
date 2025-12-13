= UX
Afin de pouvoir concevoir une expérience utilisateur adaptée à notre application Tamagotchi, nous avons défini des personas, scénarios et wireframes avant de commencer le développement. Ces outils ont pour but de favoriser une approche centrée utilisateur et de s'assurer que les besoins et attentes des utilisateurs finaux sont pris en compte dès le début du projet.
== Personas
=== Persona 1 : Sophie

#v(0.5em)
#grid(
  columns: (1fr, 2fr),
  column-gutter: 0.5em,
  image("../images/sophie.jpg", width: 94%),
  [
  *Données démographiques*
  - Âge : 34 ans
  - Activité : Graphiste indépendante
  - Situation familiale : En couple, sans enfants
  - Lieu de domicile : Lausanne
  - Lieu de travail : Télétravail à domicile
  ]
)

_"J'adorais mon Tamagotchi quand j'avais 10 ans. J'aimerais retrouver cette simplicité et ce petit plaisir quotidien, mais avec une interface moderne."_

*Présentation*

Sophie est une professionnelle créative qui travaille principalement depuis chez elle. Enfant des années 90, elle a grandi avec les premiers Tamagotchis et garde une nostalgie particulière pour ces petits compagnons virtuels qu'elle emmenait partout. Aujourd'hui, elle recherche des applications simples et relaxantes pour faire des pauses durant ses journées de travail intensif. Elle apprécie les expériences qui mêlent nostalgie et modernité, mais déteste les applications trop complexes ou chronophages.

*Objectifs*
- Retrouver le plaisir simple de s'occuper d'un compagnon virtuel
- Faire des pauses relaxantes durant sa journée de travail
- Partager cette expérience nostalgique avec ses amis du même âge

*Souhaits*
- Une interface épurée et visuellement agréable
- Des animations fluides et satisfaisantes
- Un système qui ne nécessite pas une attention constante (contrairement aux Tamagotchis originaux)
- Pouvoir personnaliser son compagnon

*Craintes*
- Que l'application devienne trop prenante et interfère avec son travail
- Que le design soit trop enfantin ou dépassé
- Perdre son compagnon à cause de notifications manquées
- Que l'application contienne trop de publicités ou d'achats in-app

*Références (alternatives actuelles)*
- Pokémon GO (pour l'aspect compagnon virtuel moderne)#footnote[@pokemon-go]
- Finch (application de bien-être avec compagnon virtuel)#footnote[@finch]
- Applications de relaxation comme Calm#footnote[@calm] ou Headspace#footnote[@headspace]

=== Persona 2 : Lucas

#v(0.5em)
#grid(
  columns: (1fr, 2fr),
  column-gutter: 0.5em,
  image("../images/lucas.jpg", width: 94%),
  [
    - Âge : 14 ans
    - Activité : Écolier
    - Situation familiale : Vit avec ses parents et sa petite sœur
    - Lieu de domicile : Genève
    - Lieu de travail/étude : Collège du quartier
  ]
)


_"J'aime bien les jeux simples où on peut débloquer des trucs. Les Tamagotchis, je connais pas vraiment, mais ça a l'air cool."_

*Présentation*

Lucas est un adolescent curieux et connecté qui passe beaucoup de temps sur son smartphone. Il découvre le concept de Tamagotchi pour la première fois mais est attiré par l'idée d'un compagnon virtuel qu'il peut personnaliser et faire évoluer. Il aime les jeux qui proposent des objectifs à atteindre et des récompenses à débloquer. Lucas est également actif physiquement (football le mercredi et samedi) et apprécie que ses activités réelles puissent avoir un impact dans ses jeux mobiles.

*Objectifs*
- S'amuser pendant les pauses au collège et les trajets
- Débloquer tous les succès et achievements
- Montrer ses progrès à ses amis
- Découvrir toutes les fonctionnalités cachées

*Souhaits*
- Un système de progression clair avec des récompenses
- Des mini-jeux amusants et variés
- Des interactions originales utilisant les capteurs du téléphone
- Pouvoir partager ses accomplissements
- Un design moderne et coloré

*Craintes*
- Que le jeu devienne répétitif trop rapidement
- Que son compagnon meure trop facilement
- Que l'application soit ennuyeuse ou trop simple
- Ne pas comprendre comment débloquer certains succès

*Références (alternatives actuelles)*
- Roblox (pour l'aspect social et personnalisation)#footnote[@roblox]
- Brawl Stars (jeux mobiles avec progression)#footnote[@brawl-stars]
- My Talking Tom (compagnon virtuel)#footnote[@my-talking-tom]
- Duolingo (pour le système de streak et gamification)#footnote[@duolingo]

== Scenario
Nous avons défini un scénario simple pour illustrer comment un utilisateur pourrait interagir avec notre application Tamagotchi au cours d'une journée typique. Il s'agit ici de la découverte de l'application par Lucas.
#image("../images/storyboard.jpg")
#text(size: 8pt)[
_Visuel généré avec chatGPT_#footnote[@chatGPT]
]

_"Lucas découvre PetSim et crée un lien avec son compagnon virtuel en interagissant avec lui au quotidien. Grâce à des actions simples et des mini-jeux, il influence directement l’évolution du compagnon. Les intéractions motivent Lucas à revenir régulièrement, tout en lui permettant de partager ses accomplissements avec ses amis."_

== Wireframes
=== Basses fidélités
#image("../images/low-fidelity.jpg", height: 90%)
=== Hautes fidélités
#image("../images/high-fidelity.jpg", height: 90%)