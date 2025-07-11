library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(shinyalert)
library(DT)
library(bslib)


thematic::thematic_shiny()

server <- function(input,output,session){
  load("../data/data_ready.Rdata")
  load("../data/date_data.Rdata")
  
  
  source("Duration_server.R",local = T)

  source("Home_server.R",local = T)
  
  source("by_project_server.R",local=T)
  
  source("by_phase_server.R",local=T)
}