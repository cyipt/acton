# Aim: create basic flow diagram of project
library(nomnoml)

# datasets are in square brackets
nom1 = nomnoml::nomnoml("
#direction: down
#.box: fill=#8f8 visual=ellipse
[PlanIt]-[<box>ACTON]
[Accessibility]-[ACTON]
[Route]-[ACTON]
[Census]-[ACTON]
")

class(nom1)
htmlwidgets::saveWidget()
webshot::appshot()
