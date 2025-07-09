load("../data/date_data.Rdata")
output$duration_timeseries_plot <- renderPlotly({
  p<- correct_date_data %>% ggplot(aes(x=Project_Phase_Actual_Start_Date,y=log(Delay_ratio)))+
    geom_point()+
    geom_smooth()+
    theme_classic()+
    labs(title = "log Delay Ratio Through Time")
  
  ggplotly(p)})