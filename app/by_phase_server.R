warning_data <- data %>% mutate(Project_Phase_Actual_Start_Date = mdy(Project_Phase_Actual_Start_Date),
                Project_Phase_Planned_End_Date = mdy(Project_Phase_Planned_End_Date),
                Project_Phase_Actual_End_Date = mdy(Project_Phase_Actual_End_Date),
                Project_Budget_Amount = as.numeric(Project_Budget_Amount)) %>% 
  mutate(Cost_ratio=Total_Phase_Actual_Spending_Amount/(Project_Budget_Amount+1e-5),
         Delay=Project_Phase_Actual_End_Date - Project_Phase_Planned_End_Date,
         Warning=case_when(
           Cost_ratio > 1 & Project_Budget_Amount > 0 & Delay < 0 ~ "Critical Cost Overrun and Delay Warning",
           Cost_ratio > 1 & Project_Budget_Amount > 0 ~ "Realized Cost Overrun Warning",
           Delay > 0 ~ "Delay warning",
           Project_Status_Name=="In-Progress" & Project_Phase_Planned_End_Date < as.Date("2025-03-31") ~ "Delay warning",
           Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount > Project_Budget_Amount & Project_Budget_Amount > 0 ~ "Early Cost Overrun Warning",
           TRUE ~ "OK"
         ))



warning_data_filtered <- eventReactive(input$byphase_plot_button,{  
warning_data %>% filter(Project_Phase_Actual_Start_Date>input$byphase_date_selector[1],
                        Project_Phase_Actual_Start_Date<input$byphase_date_selector[2],
                        Project_Phase_Name %in% input$byphase_phase_selectize,
                        Project_Status_Name %in% input$byphase_status_selectize)

})

output$byphase_barplot <- renderPlotly({
  p <- warning_data_filtered() %>% filter(Warning!="OK") %>% 
    ggplot(aes(y=Warning))+
    geom_bar()+
    facet_grid(rows=vars(Project_Status_Name),cols=vars(Project_Phase_Name))+
    theme_light()
  ggplotly(p)
})

  
