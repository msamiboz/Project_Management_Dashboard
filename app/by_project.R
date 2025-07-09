page_fluid(
  fluidRow(
    column(4,
          inputPanel(
            input_switch("byproject_completion_switch",label = "Completion Ratio",value = TRUE),
            input_switch("byproject_inprogress_switch",label = "In-Progress Ratio",value = FALSE)
          ),
          conditionalPanel(
            condition = "input.byproject_completion_switch==true",
            sliderInput("byproject_completion_range",label = "Completion Ratio Range",
                        min=0,max=1,value = c(0.5,1))
          ),
          conditionalPanel(
            condition = "input.byproject_inprogress_switch==true",
            sliderInput("byproject_inprogress_range",label = "In-Progress Ratio Range",
                        min=0,max=1,value = c(0,0.5))
          ),
          
          textOutput("byproject_ratios"),
          tags$p(" "),
          HTML("Each project consists of several phases some have 1, some have 5 etc. <br>
          Completion Ratio represents the ratio of completed phases.
          <br> Respectively In-Progress Ratio stands for In-progress phases. <br>
          
          Only other state for a phase is PNS which means Planning")
          
          ),
    column(8,
           actionButton("byproject_warning_button","Check for Warnings"),
           checkboxInput("byproject_data_checkbox","Show Project Data",value=F),
           conditionalPanel(
             condition = "input.byproject_data_checkbox==true",
             dataTableOutput("byproject_datatable")
           )
          )
  )
)
