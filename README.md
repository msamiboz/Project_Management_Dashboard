# Project_Management_Dashboard
This is a comprehensive project to conduct project management analysis and create dashboard. Using public data. See the following link for the dashboard.

https://msamiboz.shinyapps.io/ProjectManagement_Dashboard/

## Data Source 
Data is donloaded from webpage:
https://data.cityofnewyork.us/Housing-Development/Capital-Project-Schedules-and-Budgets/2xh6-psuq
its name is 
Data.gov: Capital Project Schedules and Budgets.

## Content

### Analysis

An analysis report can be found in the reports folder. that includes all the findings with the app.

### Dashboard

A shiny app includes statistical models and a observation dashboard where KPIs and warnings built on them can be examined.

### Dictionary

Dictionary can be found in the bottom of analysis_report. It contians all the terms that I used.

## Goal

Design and implement a sample dashboard for upper management.
Data analysis and modelling.

## Structure

data/
├── excel file(data)
├── excel file(metadata)
└── modified datas as Rdata

R/
├── minor R scripts
├── Analysis.R
└── data.R

app/
├── ui.R
├── server.R
├── ui(subfolders)
├── server(subfolders)
└── www/

reports/
├── analysis_report.Rmd
└── analysis_report.html

README.md
renv.lock


## Installation

```{r}
# Install required packages
renv::restore()
```

## Development
<<<<<<< Updated upstream

On features branch:
- Implemented a Chat page using [querychat](https://github.com/posit-dev/querychat). With that one can examine a dataset using natural language
- On By_project panel added some reactive functionality, fixed datatable coloring issue
- On By_phase panel added some explanations

## References

https://teachnyc.zendesk.com/hc/en-us/articles/360043956952-How-is-NYC-divided-into-school-districts



