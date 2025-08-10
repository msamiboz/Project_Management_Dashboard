library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(shinyalert)
library(DT)
library(bslib)
library(querychat)
library(purrr)
library(lubridate)
library(moments)


#thematic::thematic_shiny()
load("data_ready.Rdata")
load("date_data.Rdata")
load("clean_data.Rdata")

readRenviron("keys.Renviron")
data_source <- querychat_data_source(full_data)

querychat_config <- querychat_init(data_source = data_source,
                                   greeting = readLines("greeting.md"),
                                   create_chat_func = purrr::partial(ellmer::chat_google_gemini,model="gemini-2.5-flash-lite"))



server <- function(input,output,session){

  
  source("Duration_server.R",local = T)

  source("Home_server.R",local = T)
  
  source("by_project_server.R",local=T)
  
  source("by_phase_server.R",local=T)
  
  source("Cost_server.R",local=T)
  
  source("chat_server.R",local=T)
  
}