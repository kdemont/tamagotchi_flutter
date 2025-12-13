// Configuration du document
#set document(
  title: "AddMoApp - Rapport de projet",
  author: "Killian Demont & Robin Zweifel",
  date: auto,
)

// Configuration des footnotes (doit être avant tout contenu)
#show footnote.entry: set text(size: 9pt)

// Chargement de la bibliographie
#show: doc => {
  set bibliography(title: "Bibliographie")
  doc
}

// Mise en page
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 9pt, fill: gray)
      #grid(
        columns: (1fr, 1fr),
        align: (left, right),
        [AddMoApp - Rapport de projet],
        [Killian Demont & Robin Zweifel]
      )
      #line(length: 100%, stroke: 0.5pt + gray)
    ]
  },
  footer: context {
    if counter(page).get().first() > 1 [
      #set text(size: 9pt, fill: gray)
      #line(length: 100%, stroke: 0.5pt + gray)
      #grid(
        columns: (1fr, 1fr),
        align: (left, right),
        [#datetime.today().display("[day].[month].[year]")],
        counter(page).display("1")
      )
    ]
  },
)

// Typographie
#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "fr",
)

#set par(
  justify: true,
  leading: 0.65em,
)

// En-têtes
#set heading(numbering: "1.1")
#show heading: it => {
  it
  v(0.3em)
}
#set footnote.entry(separator: line(length: 30%, stroke: 0.5pt))

// Page de titre
#align(center)[
  #text(size: 20pt, weight: "bold")[
    AddMoApp - Rapport de projet
  ]

  #text(size: 16pt, style: "italic")[
    Application Flutter - Tamagotchi
  ]

  #v(2em)

  #text(size: 12pt)[
    Killian Demont & Robin Zweifel
  ]


  #text(size: 11pt)[
    #datetime.today().display("[day].[month].[year]")
  ]
  #v(4em)
  #image(
    "illustration.jpg",
    width: auto
  )

]

#pagebreak()

// Corps du rapport
#include "sections/abstract.typ"
#pagebreak()
#outline()
#pagebreak()
#include "sections/introduction.typ"
#pagebreak()
#include "sections/ux.typ"
#pagebreak()
#include "sections/evaluations.typ"
#pagebreak()
#include "sections/technique.typ"
#pagebreak()
#include "sections/tests.typ"
#pagebreak()
#include "sections/futur_du_travail.typ"
#pagebreak()
#include "sections/conclusion.typ"
#pagebreak()
#bibliography("references.yml", style: "apa")
#pagebreak()
#include "sections/annexes.typ"