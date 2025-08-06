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
           HTML("<p>These are options for the warnings</p>"),
           fluidRow(column(4,tooltip(HTML("<p>Delay</p>"),"There is a delay in the project")),
                      column(4,tooltip(HTML("<p>Cost</p>"),"Cost Ratio is over 1")),
                      column(4,tooltip(HTML("<p>Both</p>"),"There is a delay and cost ratio is over 1"))),
           selectizeInput("warning_type",
                          "Select warnings to consider:",
                          list("Cost"="Cost Overrun",
                               "Delay"="Delay",
                               "Both"="Delay and Cost Overrun"),
                          multiple=TRUE,
                          selected="Delay and Cost Overrun"
           ),
           actionButton("byproject_warning_button","Check for Warnings"),
           checkboxInput("byproject_data_checkbox","Show Project Data",value=F),
           conditionalPanel(
             condition = "input.byproject_data_checkbox==true",
             dataTableOutput("byproject_datatable")
           )
          )
  )
)
