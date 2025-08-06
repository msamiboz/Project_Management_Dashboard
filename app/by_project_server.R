
data1 <- data %>% group_by(Project_Building_Identifier,Project_School_Name,Project_Description) %>%
  summarise(complete_count=sum(Project_Status_Name=="Complete"),
            inprogress_count=sum(Project_Status_Name=="In-Progress"),count=n()) %>%
  mutate(completion_ratio=complete_count/count,
         inprogress_ratio=inprogress_count/count)


full_data <- data %>% mutate(Project_Phase_Actual_Start_Date = mdy(Project_Phase_Actual_Start_Date),
                             Project_Phase_Planned_End_Date = mdy(Project_Phase_Planned_End_Date),
                             Project_Phase_Actual_End_Date = mdy(Project_Phase_Actual_End_Date),
                             Project_Budget_Amount = as.numeric(Project_Budget_Amount)) %>% 
  group_by(Project_Building_Identifier,Project_School_Name,Project_Description) %>% 
  summarise(Project_Start_Date=min(Project_Phase_Actual_Start_Date),
            Project_Planned_End_Date=max(Project_Phase_Planned_End_Date),
            Project_Actual_End_Date=max(Project_Phase_Actual_End_Date),
            Project_Budget_Amount=sum(Project_Budget_Amount),
            Project_Spending = sum(Total_Phase_Actual_Spending_Amount)) %>% 
  mutate(Cost_ratio = round(Project_Spending/(Project_Budget_Amount+1e-5),digits = 2),
         delay=Project_Planned_End_Date-Project_Actual_End_Date)

data_warning <- 
  full_data %>% mutate(Warning = case_when(
    delay > 0 & Cost_ratio > 1 ~ "Delay and Cost Overrun",
    delay > 0 ~ "Delay",
    Cost_ratio > 1 ~ "Cost Overrun",
    TRUE ~ "Ok!")
  )

output$byproject_ratios <- renderText({
  if(input$byproject_completion_switch){
    if (input$byproject_inprogress_switch) {
      value <- data1 %>% filter(completion_ratio>=input$byproject_completion_range[1],
                                completion_ratio<=input$byproject_completion_range[2],
                                inprogress_ratio>=input$byproject_inprogress_range[1],
                                inprogress_ratio<=input$byproject_inprogress_range[2]) %>% nrow()
    }else{
      value <- data1 %>% filter(completion_ratio>=input$byproject_completion_range[1],
                                completion_ratio<=input$byproject_completion_range[2]) %>% nrow()
    }
  }else if (input$byproject_inprogress_switch){
      value <- data1 %>% filter(inprogress_ratio>=input$byproject_inprogress_range[1],
                                inprogress_ratio<=input$byproject_inprogress_range[2]) %>% nrow()
    }else{
      value <- nrow(data1)
  }

  paste("Over 7519 Project,",value,"projects satisfies given filters.")
}
)

output$byproject_datatable <- DT::renderDataTable({
  if(input$byproject_warning_button){
    DT::datatable(data_warning,filter="top",
                  style="default",
              selection = "none",
              extensions = c("Scroller"),
              options = list(stripeClasses=NULL,
                             scrollY=650,
                             scrollX=500,
                             autoWidth=FALSE,
                             scroller=TRUE),
              rownames = FALSE) %>%
      DT::formatStyle(columns = "Warning",
                  target = "row",
                  backgroundColor = styleEqual(c("Delay and Cost Overrun",
                                                 "Delay",
                                                 "Cost Overrun",
                                                 "Ok!"),
                                               c("#df382c","#efb73e","#e95420","transparent")
                                                                        )
                                           )
  }else{
    datatable(full_data,
              extensions = c("Scroller"),
              options = list(scrollY=650,
                             scrollX=500,
                             autoWidth=FALSE,
                             scroller=TRUE),
              rownames = FALSE)
  }
}
)




observeEvent(input$byproject_warning_button,{
  warned_projects <- data_warning %>% filter(Warning %in% isolate(input$warning_type))
  if (nrow(warned_projects)>0) {
    shinyalert(title = "Warning!",
               text = paste(nrow(warned_projects),"projects need attention"),
               type = "warning")
  }
  
})











