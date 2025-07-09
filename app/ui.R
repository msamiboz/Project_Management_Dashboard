library(shiny)
library(bslib)
library(plotly)

ui <- page_navbar(
  nav_panel("Home",source("Home.R",local = T)$value),
  nav_panel("Project Duration",source("Duration.R",local = T)$value),
  nav_panel("Cost","Cost analysis content"),
  nav_panel("Times series Analysis","Times series Analysis content"),
  nav_panel("By Project",source("by_project.R",local=T)$value),
  nav_panel("About","About content"),
  title = "Project Management Dashboard",
  id="page"
)