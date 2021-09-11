{
  library(shiny)
  library(shinydashboard)
  library(tidyverse)

}


header <- shinydashboard::dashboardHeader(
  title = "Seepi Status"
)


sidebar <- shinydashboard::dashboardSidebar(
  shiny::sliderInput(
    "refresh_rate_t", "Refresh rate of Temperature [s]",
    min = 0.5, max = 10, value = 1, step = 0.5
  ),
  shiny::sliderInput(
    "refresh_rate_s", "Refresh rate of Storage [min]",
    min = 1, max = 5, value = 1, step = 1
  ),
  menuItem("Dashboard", tabName = "dashboard")
)

body <-   shinydashboard::dashboardBody(
#  shinydashboard::tabItems(
#    shinydashboard::tabItem(
      shiny::fluidRow(
        shinydashboard::valueBoxOutput(
          "temperature",
          400
        )
      ),
      br(),
      shiny::fluidRow(
        shiny::column(6, shiny::plotOutput("main_storage")),
        shiny::column(6, shiny::plotOutput("ram_storage"))
      )
#      )
#    )
)


ui <- shinydashboard::dashboardPage(
  skin = "black",
  title = "SeePi Status",
  header,
  sidebar,
  body

)
