page_fluid(

  inputPanel(
  dateRangeInput("byphase_date_selector",start = "2003-09-12",end = "2025-03-31",min = "2003-09-12",max="2025-03-31",label = "Project start date",startview = "decade"),
  selectInput("byphase_phase_selectize",multiple=T,selected = list("Scope","Design","Purch & Install","Construction","CM,F&E"),
                 choices=list("Scope","Design","Purch & Install","Construction","CM,F&E"),
                 label="Pick Phases to Analyse"),
  selectInput("byphase_status_selectize",multiple=T,selected = list("In-Progress","Complete"),
                 choices=list("In-Progress","Complete"),label="Pick Status to Analyse"),
  actionButton("byphase_plot_button","Plot")
  ),
  plotlyOutput(outputId = "byphase_barplot"),
  HTML("<p>To catch the allocation of categorical variables through dataset by phase below plot can be used.</p>"),
  selectInput(inputId = "column",
              label="Select a column to plot",
              choices=list("Project_Phase_Name","Project_Status_Name","Project_Type")),
  
  plotOutput(outputId = "home_pie_plot")
  
)