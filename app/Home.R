collist <- list("Project_Geographic_District",
                "Project_Building_Identifier",
                "Project_School_Name",
                "Project_Type",
                "Project_Description",
                "Project_Phase_Name",
                "Project_Status_Name",
                "Project_Phase_Actual_Start_Date",
                "Project_Phase_Planned_End_Date",
                "Project_Phase_Actual_End_Date",
                "Project_Budget_Amount",
                "Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount",
                "Total_Phase_Actual_Spending_Amount")

page_fluid(
 HTML("<p>In this app Users can dive into Project duration and cost analyese done on Data.gov: Capital Project Schedules and Budgets dataset.</p>"),
 HTML("<p>Also to observe projects and examine the critical projects in perspective of project as a whole, or phases one can use respective panels.</p>"),
 tags$footer("This app is designed by Mehmet Sami Boz",style="position:fixed;bottom:0;"),
 hr(),
 selectInput( 
     "home_column_selected", 
     "Select a column to summarize:", 
     collist
   ),
 uiOutput("home_summary_table"),
 hr(),
 inputPanel(width="100%",
   HTML("<p>To understand column structure use below plotting feature</p>"),
   #column select,
   radioButtons(
     "home_plot_type",
     "Pick plot type:",
     choices = list("point","histogram"),
     inline = T
   ),
   selectInput("home_plot_y",
                "Pick a data column",
                choices = list("Start Date"="Project_Phase_Actual_Start_Date",
                               "Planned End Date"="Project_Phase_Planned_End_Date",
                               "Actual End Date"="Project_Phase_Actual_End_Date",
                               "Budget"="Project_Budget_Amount",
                               "Estimated Cost"="Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount",
                               "Actual Spending"="Total_Phase_Actual_Spending_Amount"),
               width = "150%"
                ),
   selectInput("home_plot_x",
                "Pick an identifier column",
                choices = list("Geographic District"="Project_Geographic_District",
                               "Phase Name"="Project_Phase_Name",
                               "Type"="Project_Type",
                               "Status"="Project_Status_Name")),
   #optional picks facets,coloring etc.
   actionButton("home_plot_button","Plot"),
   
 ),
 plotOutput(width = "50%","home_plot"),
 br()
 
           
           
           
           
)
