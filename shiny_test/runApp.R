{
  library(shiny)
  library(shinydashboard)
  library(tidyverse)
}

shiny::runApp(appDir = "/app", port = 8080, host = "0.0.0.0")
