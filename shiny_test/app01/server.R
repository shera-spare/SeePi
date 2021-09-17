{
  library(shiny)
  library(shinydashboard)
  library(tidyverse)
}

server <- function(input, output, session) {

  temperature <- shiny::reactiveValues()
  storage <- shiny::reactiveValues()
  temperature$color <- "green"

  output$temperature <- shinydashboard::renderValueBox({
     shinydashboard::valueBox(
       temperature$rasppi, "Temperature [C]",
       icon = shiny::icon("thermometer-half"),
       color = temperature$color
     )

  })

  shiny::observe({
    shiny::invalidateLater(
      as.numeric(input$refresh_rate_t * 1000),
      session
    )
    temperature$rasppi <- RasPi::get_cpu_temp_c()

    if(temperature$rasppi <= 60) {
      temperature$color = "green"
    } else if (temperature$rasppi > 60 && temperature$rasppi <= 80) {
      temperature$color = "yellow"
    } else if (temperature$rasppi > 80) {
      temperature$color = "red"
    }

  })

  shiny::observe({
    shiny::invalidateLater(
      as.numeric(input$refresh_rate_s * 1000),
      session
    )

    storage$harddrive <- RasPi::get_storage_amount()
    storage$RAM <- RasPi::get_storage_amount()


  })

  output$main_storage <- shiny::renderPlot({
    plot_storage_pieplot(
      data_set = storage$harddrive,
      is_hdd = TRUE
    )

  })

  output$ram_storage <- shiny::renderPlot({
    plot_storage_pieplot(
      data_set = storage$RAM,
      is_hdd = TRUE
    )

  })








}
