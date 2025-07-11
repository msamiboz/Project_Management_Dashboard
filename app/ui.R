library(shiny)
library(bslib)
library(plotly)
library(ggplot2)

ui <- page_navbar(
  theme  = bslib::bs_theme(version=5,bootswatch = "united"),
  nav_spacer(),
  nav_panel("Home",source("Home.R",local = T)$value),
  nav_panel("Project Duration",source("Duration.R",local = T)$value),
  nav_panel("Cost",source("Cost.R",local = T)$value),
  nav_panel("By Project",source("by_project.R",local=T)$value),
  nav_panel("By Phase",source("by_phase.R",local=T)$value),
  nav_item(input_dark_mode()),
  title = "Project Management Dashboard",
  id="page"
)