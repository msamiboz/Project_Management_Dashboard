library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)


server <- function(input,output,session){
  
  source("Duration_server.R",local = T)

  source("Home_server.R",local = T)
}