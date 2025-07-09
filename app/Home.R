page_fluid(
  selectInput(inputId = "column",
                       label="Select a column to plot",
                       choices=list("Project_Phase_Name","Project_Status_Name","Project_Type")),
  
  plotOutput(outputId = "home_pie_plot")
           
           
           
           
)