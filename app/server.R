library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(shinyalert)
library(DT)

server <- function(input,output,session){
  
  source("Duration_server.R",local = T)

  source("Home_server.R",local = T)
  
  source("by_project_server.R",local=T)
}